import os
import re

def refactor_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Imports
    content = content.replace('on_boarding_screen4.dart', 'on_boarding_screen_tmp3.dart')
    content = content.replace('on_boarding_screen3.dart', 'on_boarding_screen_tmp2.dart')
    content = content.replace('on_boarding_screen2.dart', 'on_boarding_screen_tmp1.dart')
    content = content.replace('on_boarding_screen1.dart', 'welcome_screen.dart')

    content = content.replace('on_boarding_screen_tmp3.dart', 'on_boarding_screen3.dart')
    content = content.replace('on_boarding_screen_tmp2.dart', 'on_boarding_screen2.dart')
    content = content.replace('on_boarding_screen_tmp1.dart', 'on_boarding_screen1.dart')
    
    # Class usage and definitions
    content = content.replace('OnBoardingScreen4', 'OnBoardingScreenTmp3')
    content = content.replace('OnBoardingScreen3', 'OnBoardingScreenTmp2')
    content = content.replace('OnBoardingScreen2', 'OnBoardingScreenTmp1')
    content = content.replace('OnBoardingScreen1', 'WelcomeScreen')
    
    content = content.replace('OnBoardingScreenTmp3', 'OnBoardingScreen3')
    content = content.replace('OnBoardingScreenTmp2', 'OnBoardingScreen2')
    content = content.replace('OnBoardingScreenTmp1', 'OnBoardingScreen1')
    
    with open(filepath, 'w') as f:
        f.write(content)

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            refactor_file(os.path.join(root, file))

print("done")
