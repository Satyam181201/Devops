import os
from datetime import datetime

DATA_FILE = '/app/data/notes.txt'

def read_notes():
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            return f.read()
    return "No notes yet!"

def add_note(note):
    with open(DATA_FILE, 'a') as f:
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        f.write(f"[{timestamp}] {note}\n")

# Main
print("=== Note App ===")
print("\nExisting notes:")
print(read_notes())

# Add new note
new_note = input("\nAdd a note (or press Enter to skip): ")
if new_note:
    add_note(new_note)
    print("Note saved!")

print("\nAll notes:")
print(read_notes())
