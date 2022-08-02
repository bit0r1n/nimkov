# Package

version       = "1.0.4"
author        = "bit0r1n"
description   = "Text generator, based on Markov Chains (Markov text generator)"
license       = "MIT"

# Dependencies

requires "nim >= 0.20.0"


task genDoc, "Generates the documentation for nimkov":
    rmDir("docs")
    exec("nim doc2 --outdir=docs --project --index:on --git.url:https://github.com/bit0r1n/nimkov --git.commit:master nimkov.nim")
    exec("nim buildindex -o:docs/theindex.html docs/")

    writeFile("docs/CNAME", "nimkov.bitor.in")
    writeFile("docs/index.html", """
    <!DOCTYPE html>
    <html>
      <head>
        <meta http-equiv="Refresh" content="0; url=nimkov.html"/>
      </head>
      <body>
        <p>Click <a href="nimkov.html">this link</a> if this does not redirect you.</p>
      </body>
    </html>
    """)