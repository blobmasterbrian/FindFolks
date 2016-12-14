from FindFolks import create_app  #import create_app function from FindFolks/__init.py__
app = create_app()  # call function
app.run(debug = True, host = "127.0.0.1", port = 8888)  # run app on localhost port 8888
