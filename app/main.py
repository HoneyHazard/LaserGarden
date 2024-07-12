import sys
import signal
import logging
import getch
import os
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from config import parse_arguments
from utils import change_to_parent_dir_if_in_main, parse_qlc_workspace
from utils import SceneManager
from dmx_array import DMXArray

if __name__ == "__main__":


    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    change_to_parent_dir_if_in_main()

    args = parse_arguments()

    # Enable the virtual keyboard
    os.environ['QT_IM_MODULE'] = 'qtvirtualkeyboard'
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    target_ip = args.get('target_ip', None)
    initial_preset = args.get('preset', None)
    dmx_array = DMXArray(target_ip, initial_preset)
    if args.get('ola002', False):
        dmx_array.ola002 = True
    engine.rootContext().setContextProperty("dmxArray", dmx_array)

    qlc_workspace = args.get('qlc_workspace', None)
    if qlc_workspace:
        logging.info(f"Importing QLC workspace: {qlc_workspace}")
        scenes = parse_qlc_workspace(qlc_workspace)

   # Initialize SceneManager
    scene_manager = SceneManager()
    scenes = scene_manager.scenes

    # Pass the scenes to QML
    engine.rootContext().setContextProperty("sceneManager", scene_manager)

    engine.load(QUrl("app/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)


    def save_last_config_on_exit():
        dmx_array.save_last_config()
        dmx_array.set_all_channels_to_zero()
        logging.info("Saved last configuration and set all channels to 0 on exit")

    app.aboutToQuit.connect(save_last_config_on_exit)

    def signal_handler(sig, frame):
        print('Ctrl+C pressed, exiting...')
        app.quit()

    signal.signal(signal.SIGINT, signal_handler)

    sys.exit(app.exec())
