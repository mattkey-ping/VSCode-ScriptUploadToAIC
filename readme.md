# Integrate Script Upload to AIC into VS Code

## Prerequisites

1. Install [Frodo CLI](https://github.com/rockcarver/frodo-cli) and ensure it is in your `$PATH`.

## Configure VS Code

1. Create a `.vscode` folder in the root of your VS Code workspace.
2. Copy the contents of `VSCode-ScriptUploadToAIC` into the `.vscode` folder.
3. Symlink `keybindings.json` from `.vscode` to VS Code's built-in keybindings file (run from within `.vscode`):

   ```sh
   ln -s ~"/Library/Application Support/Code/User/keybindings.json" ./keybindings.json
   ```

4. Update `keybindings.json`:
   - If it already contains an array of objects, add the object from `keybinding-sample.json` to that array.
   - Otherwise, replace the empty file with the full JSON from `keybinding-sample.json`.

## Install ScriptUploadToAIC

1. Make the script executable:

   ```sh
   chmod 775 scriptUploadToAIC
   ```

2. Create the script folders:
   - **Default folder structure:** run and then copy the created folder structure to your preferred location:

     ```sh
     ./createFolders.sh
     ```

   - **Custom folder structure:** Edit `folderMappings.json` and update the `"folder"` values to match your directory names. For example, to store Scripted Decision Node scripts in a folder called `SDNs`, find `"type": "Scripted Decision Node"` and change `"folder": "ScriptedDecision"` to `"folder": "SDNs"`.

3. (Optional) Set the `$WORKING_TENANT` environment variable in your shell profile to reduce prompting for a specific Frodo connection alias (do not set if you want to switch between tenants often). For zsh, add to `~/.zprofile`:

   ```sh
   export WORKING_TENANT=myTenant
   ```

   > **Note:** VS Code must be restarted after modifying this variable.

## Usage

1. Create a script file in a folder that matches an entry in `folderMappings.json`.
   - Example: `scripts/Libraries/examples/myLibScript.js` will be imported as a **Library** script.
   - If no matching folder is found, the script will be imported using the `"default"` type.
2. Save the file with `Cmd S` (optional).
3. Upload the file with `Cmd U`.
   - On subsequent uploads, `Cmd U` will automatically save and then upload.
