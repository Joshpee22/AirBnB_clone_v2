from fabric.api import local
from time import strftime

def do_pack():
    date = strftime("%Y%m%d%H%M%S")
    try:
        print("Creating versions directory...")
        local("mkdir -p versions")

        print("Creating .tgz archive...")
        result = local("tar -cvzf versions/web_static_{}.tgz web_static".format(date), capture=True)

        if result.succeeded:
            archive_path = "versions/web_static_{}.tgz".format(date)
            print("Archive created successfully:", archive_path)
            return archive_path
        else:
            print("Error creating archive.")
            return None

    except Exception as e:
        print("Error:", e)
        return None

# Run the script
do_pack()

