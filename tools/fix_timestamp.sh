find D240x -print | while read filename; do
    # do whatever you want with the file
    touch -d "$(date -R -r "$filename") + 2 hours" "$filename"
done
