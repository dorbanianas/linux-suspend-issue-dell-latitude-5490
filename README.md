# linux-suspend-issue-dell-latitude-5490

## Issue Summary
Many users of the Dell Latitude 5490, particularly those running Linux distributions like Fedora, have reported issues with the system failing to resume properly after being suspended. This is often related to power management features and Intel graphics settings, specifically the `i915` driver.

### Common Symptoms
- System freezes upon resuming from suspend.
- Blank screen after suspend.
- Degraded performance or system instability after waking.

### Root Cause
The problem is linked to Intel's `i915` graphics driver, particularly its **display power management settings**. Disabling the `DC` state (`Display C-States`) using the kernel parameter `i915.enable_dc=0` can often resolve the issue.

## Solution
The issue can be resolved by modifying the GRUB configuration to include the `i915.enable_dc=0` kernel parameter.

## Script Fix
1. **Download the Script**
   Save the Bash script as `update_grub.sh` to your desired directory.

2. **Make the Script Executable**
   Open a terminal, navigate to the directory containing the script, and make it executable:
   ```bash
   chmod +x update_grub.sh
   ```

3. **Run the Script**
   Execute the script with root privileges to apply the changes:
   ```bash
   sudo ./update_grub.sh
   ```

4. **Reboot the System**
   Once the script completes successfully, reboot your system for the changes to take effect:
   ```bash
   sudo reboot
   ```

### Expected Behavior
- The script backs up the current GRUB configuration file to `/etc/default/grub.backup`.
- It appends the `i915.enable_dc=0` parameter to the `GRUB_CMDLINE_LINUX` line.
- Updates the GRUB configuration file, handling UEFI and BIOS configurations automatically.
- Prompts you to reboot the system.

### Troubleshooting
- If the script fails, ensure it is run with `sudo` or as the root user.
- Verify the GRUB configuration changes:
  ```bash
  cat /etc/default/grub | grep GRUB_CMDLINE_LINUX
  ```
  Ensure `i915.enable_dc=0` is included.
- Check the backup file at `/etc/default/grub.backup` if you need to restore the original configuration.

## Manual Fix
### Steps
1. Open a terminal and edit the GRUB configuration:
   ```bash
   sudo nano /etc/default/grub
   ```
2. Locate the line starting with `GRUB_CMDLINE_LINUX`.
3. Add the `i915.enable_dc=0` parameter to the end of the existing string, ensuring parameters are separated by spaces. Example:
   ```makefile
   GRUB_CMDLINE_LINUX="rhgb quiet i915.enable_dc=0"
   ```
4. Save and close the file.
5. Update the GRUB configuration:
   - For legacy BIOS:
     ```bash
     sudo grub2-mkconfig -o /boot/grub2/grub.cfg
     ```
   - For UEFI:
     ```bash
     sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
     ```
6. Reboot the system:
   ```bash
   sudo reboot
   ```

### Automated Fix
For convenience, a Bash script has been created to automate this process.

---
This fix has been confirmed to work on Dell Latitude 5490 with Intel i3 8th Gen processors. Feedback and contributions are welcome.