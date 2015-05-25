sudo rsync -av --exclude /proc --exclude /dev --exclude /sys --exclude /var /  user@host:/backup/`hostname -s`

