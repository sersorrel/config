use i3_ipc::{reply::Workspace, Connect, I3};
use nix::unistd::getuid;
use std::{env, fs, path::PathBuf};

fn get_other_workspace(workspaces: &[Workspace], output: &str) -> Option<String> {
    let workspaces_on_this_output = workspaces.iter().filter(|w| w.output == *output).count();
    if workspaces_on_this_output == 2 {
        let current_workspace = workspaces
            .iter()
            .filter(|w| w.focused)
            .map(|w| &w.name)
            .next()
            .unwrap();
        Some(
            workspaces
                .iter()
                .filter(|w| w.output == *output && w.name != *current_workspace)
                .map(|w| w.name.clone())
                .next()
                .unwrap(),
        )
    } else {
        None
    }
}

fn main() {
    let uid = getuid().as_raw();
    let mut i3 = I3::connect().unwrap();
    let workspaces = i3.get_workspaces().unwrap();
    let output = workspaces
        .iter()
        .filter(|w| w.focused)
        .map(|w| &w.output)
        .next()
        .unwrap();
    let mut old_output_path = PathBuf::from("/var/run/user");
    old_output_path.push(uid.to_string());
    old_output_path.push("i3backandforthd");
    old_output_path.push("old");
    old_output_path.push(&output);
    let next_workspace = match fs::read(old_output_path).map(|x| String::from_utf8(x).unwrap()) {
        Ok(maybe_next_workspace) => {
            let switching_to_output = workspaces
                .iter()
                .filter(|w| w.name == maybe_next_workspace)
                .map(|w| &w.output)
                .next();
            if switching_to_output.is_some() && output != switching_to_output.unwrap() {
                eprintln!("backandforthd bug!");
                get_other_workspace(&workspaces, output)
            } else {
                Some(maybe_next_workspace)
            }
        }
        Err(_) => get_other_workspace(&workspaces, output),
    };
    if let Some(next_workspace) = next_workspace {
        match env::args_os().nth(1).as_ref().map(|s| s.to_str().unwrap()) {
            Some("-n") | Some("--dry-run") => println!("{}", next_workspace),
            _ => i3
                .run_command(format!("workspace {}", next_workspace))
                .unwrap()
                .into_iter()
                .for_each(|x| {
                    if !x.success {
                        panic!(
                            "Error running command 'workspace {}': {}",
                            next_workspace,
                            x.error.as_deref().unwrap_or("(no message)")
                        );
                    }
                }),
        }
    }
}
