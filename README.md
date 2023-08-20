# AYTextView

Thank you checking out AYTextView. This is a text formatting tool for iOS Apps which uses UITextView and NSAttributedString. 

![AYTextView](https://github.com/yashAIML2797/AYTextView/assets/79745408/19062641-7a66-4eb1-a4d0-3242ba4513e6)
# Here are some features to make your note taking more interesting.
1. Bullets
2. Numbers
3. Checklists
4. Indent Right
5. Indent Left
6. Adding photos from galley or camera.
7. Bold
8. Underline
9. Strikethrough
10. Font Size

# How to use
Add AYTextView framework to your project.
import NoteTextView in your ViewController and use the code below
```
import UIKit
import AYTextView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView = AYTextView()
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
```

# Supported OS
iOS 15 and above


# Author
Yash Uttekar

# Note
To use camera to click photo and use it as a photo attachment, In your project’s ```info.plist``` add this key ```Privacy - Camera Usage Description``` with required string message.

I'm always looking to improve this project. If you would like to contribute fork the repo and open a pull request with your changes.

# Licence
Copyright (c) 2023 Yash Uttekar yash.uttekar2797@icloud.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
