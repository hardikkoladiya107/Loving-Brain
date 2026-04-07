import os
import re

def fix_imports(file_path):
    with open(file_path, 'r') as f:
        content = f.read()
    
    # We will just replace relative paths with corrected relative paths based on depth.
    # Since all files are in lib/ui/auth/... they are 4 levels deep from project root instead of 3.
    # So we just add one '../' to any import that goes up relative to 'lib/ui' (meaning they use '../').
    # Actually wait! 
    # If login_screen.dart is in lib/ui/auth/login/:
    # '../register' -> '../register' (valid, goes to ui/auth/register)
    # '../forgot_password' -> '../forgot_password' (valid)
    # '../base_screen' -> '../../base_screen' (needs to change)
    # '../widget' -> '../../widget' (needs to change)
    # '../parent_profile' -> '../../parent_profile' (needs to change)
    # '../../gen' -> '../../../gen'
    # '../../other' -> '../../../other'
    # '../../main.dart' -> '../../../main.dart'
    # '../../../repo' -> '../../../../repo'
    # '../../../model' -> '../../../../model'
    # '../../../generated' -> '../../../../generated'
    
    # It's much easier to just do simple replacements. 
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        if line.startswith('import '):
            # Replace things that are known to be outside auth
            line = re.sub(r"import\s+'\.\./\.\./\.\./", "import '../../../../", line)
            line = re.sub(r"import\s+'\.\./\.\./", "import '../../../", line)
            line = re.sub(r"import\s+'\.\./widget", "import '../../widget", line)
            line = re.sub(r"import\s+'\.\./base_screen", "import '../../base_screen", line)
            line = re.sub(r"import\s+'\.\./parent_profile", "import '../../parent_profile", line)
            # The only ones that should NOT get an extra ../ are siblings inside auth: login, register, forgot_password, on_boarding.
            # But the regex above just explicitly targets things like '../widget'.
        new_lines.append(line)
        
    with open(file_path, 'w') as f:
        f.write('\n'.join(new_lines))

for root, dirs, files in os.walk('lib/ui/auth'):
    for file in files:
        if file.endswith('.dart'):
            fix_imports(os.path.join(root, file))
print("Imports fixed.")
