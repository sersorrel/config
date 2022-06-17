use i3_ipc::{Connect, I3};

fn main() {
    let mut i3 = I3::connect().unwrap();
    let outputs: Vec<_> = i3
        .get_outputs()
        .unwrap()
        .into_iter()
        .filter(|o| o.active)
        .collect();
    if outputs.len() != 2 {
        return;
    }
    let workspaces = i3.get_workspaces().unwrap();
    let active_output = workspaces
        .iter()
        .filter(|w| w.focused)
        .map(|w| &w.output)
        .next()
        .unwrap();
    let inactive_output = outputs
        .iter()
        .filter(|o| o.name != *active_output)
        .map(|o| &o.name)
        .next()
        .unwrap();
    let inactive_workspace = workspaces
        .iter()
        .filter(|w| w.output != *active_output && w.visible)
        .map(|w| &w.name)
        .next()
        .unwrap();
    let command = format!("focus output {active_output}, move workspace to output {inactive_output}, workspace {inactive_workspace}, move workspace to output {active_output}", active_output=active_output, inactive_output=inactive_output, inactive_workspace=inactive_workspace);
    i3.run_command(&command).unwrap().into_iter().for_each(|x| {
        if !x.success {
            panic!(
                "Error running command '{command}': {}",
                x.error.as_deref().unwrap_or("(no message)"),
                command = command
            );
        }
    });
}
