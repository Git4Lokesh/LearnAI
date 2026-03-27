#!/usr/bin/env python3
"""
Redistributes correct answers across option1-4 in seed SQL files.
Usage: python3 scripts/fix_answer_distribution.py <filename.sql>
"""

import sys
import re
import random

def process_file(filename):
    with open(filename, 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    random.seed(42)
    
    changed = 0
    total = 0
    new_lines = []
    
    for line in lines:
        if "'JEE Mains Prep'" not in line or "'option1'" not in line:
            new_lines.append(line)
            if "'JEE Mains Prep'" in line:
                total += 1
            continue
        
        total += 1
        
        # Only change ~65% of option1 answers
        if random.random() > 0.65:
            new_lines.append(line)
            continue
        
        # Find all quoted strings using regex
        pattern = r"'(?:[^']|'')*'"
        matches = list(re.finditer(pattern, line))
        
        if len(matches) < 10:
            new_lines.append(line)
            continue
        
        # Indices: 0=question, 1=opt1, 2=opt2, 3=opt3, 4=opt4, 5=correct_answer, 6=solution, ...
        # Verify index 5 is 'option1'
        correct_match = matches[5]
        if correct_match.group() != "'option1'":
            new_lines.append(line)
            continue
        
        # Pick random target
        target_num = random.choice([2, 3, 4])
        
        # Get the text of option1 and target option
        opt1_match = matches[1]
        target_match = matches[target_num]
        
        opt1_text = opt1_match.group()
        target_text = target_match.group()
        
        # Build new line with swaps (replace from right to left)
        chars = list(line)
        
        # Sort replacements by position descending
        replacements = sorted([
            (correct_match.start(), correct_match.end(), f"'option{target_num}'"),
            (target_match.start(), target_match.end(), opt1_text),
            (opt1_match.start(), opt1_match.end(), target_text),
        ], key=lambda x: x[0], reverse=True)
        
        new_line = line
        for start, end, new_text in replacements:
            new_line = new_line[:start] + new_text + new_line[end:]
        
        new_lines.append(new_line)
        changed += 1
    
    with open(filename, 'w') as f:
        f.write('\n'.join(new_lines))
    
    # Verify
    result = '\n'.join(new_lines)
    print(f"File: {filename}")
    print(f"Total questions: {total}")
    print(f"Redistributed: {changed}")
    for opt in ['option1', 'option2', 'option3', 'option4']:
        count = result.count(f"'{opt}'")
        pct = round(count / total * 100) if total > 0 else 0
        print(f"  {opt}: {count} ({pct}%)")

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python3 scripts/fix_answer_distribution.py <filename.sql>")
        sys.exit(1)
    process_file(sys.argv[1])
