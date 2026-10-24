test-local:
  bluebuild rebase --tempdir /var/tmp recipes/vauxite.yml

build recipe="vauxite":
  bluebuild build --tempdir /var/tmp recipes/{{recipe}}.yml

generate-iso:
  sudo bluebuild generate-iso --iso-name vauxite-latest.iso image ghcr.io/winblues/vauxite:latest

generate-local-iso:
  sudo bluebuild generate-iso --tempdir /var/tmp --iso-name vauxite-latest.iso recipe recipes/vauxite-base.yml

# --- Aerinite ---------------------------------------------------------------

# Build the Aerinite image locally
aerinite:
  bluebuild build --tempdir /var/tmp recipes/aerinite.yml

# Build + rebase this machine onto the local Aerinite image
aerinite-test-local:
  bluebuild rebase --tempdir /var/tmp recipes/aerinite.yml

# ISO from the published Aerinite image (after the first CI build)
aerinite-iso:
  sudo bluebuild generate-iso --tempdir /var/tmp --iso-name aerinite-latest.iso image ghcr.io/ciphervlt/aerinite:latest

# Boot the ISO in a VM shaped like low-end hardware (2 cores, 4 GB)
aerinite-vm:
  [ -f /var/tmp/aerinite-test.qcow2 ] || qemu-img create -f qcow2 /var/tmp/aerinite-test.qcow2 64G
  qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 -cdrom aerinite-latest.iso -boot d \
    -drive file=/var/tmp/aerinite-test.qcow2,if=virtio,format=qcow2 -vga virtio
