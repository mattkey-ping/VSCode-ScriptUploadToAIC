# Integrate Script Upload to AIC into VS Code

## Prerequisites

1. Install [Frodo CLI](https://github.com/rockcarver/frodo-cli) and ensure it is in your `$PATH`.

## Configure VS Code

1. Create a `.vscode` folder in the root of your VS Code workspace.
2. Copy the contents of `VSCode-ScriptUploadToAIC` into the `.vscode` folder.
3. Change permissions on the install script and then execute from the command line

     ```sh
     chmod 775 installBinding.sh
      ```

4. (Optional) Move the Scripts folder to a preferred location.

5. (Optional) Set the `$WORKING_TENANT` environment variable in your shell profile to reduce prompting for a specific Frodo connection alias (do not set if you want to switch between tenants often). For zsh, add to `~/.zprofile`:

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
