#!/usr/bin/python
# from: https://github.com/Supervisor/supervisor/issues/712#issuecomment-184668764
import sys
import os
import logging
import subprocess
import time

from supervisor.childutils import listener

def main(args):
    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG, format='%(asctime)s %(levelname)s %(filename)s: %(message)s')
    logger = logging.getLogger("supervisord-watchdog")
    debug_mode = True if 'DEBUG' in os.environ else False

    while True:
        logger.info("Listening for events...")
        headers, body = listener.wait(sys.stdin, sys.stdout)
        body = dict([pair.split(":") for pair in body.split(" ")])

        logger.debug("Headers: %r", repr(headers))
        logger.debug("Body: %r", repr(body))
        logger.debug("Args: %r", repr(args))

        if debug_mode: continue

        try:
            if headers["eventname"] == "PROCESS_STATE_FATAL":
                logger.info("Process entered FATAL state...")
                if not args or body["processname"] in args:
                    logger.error("Sending TERM signal to supervisord instance ...")
                    subprocess.call(["/bin/kill", "-15", "1"], stdout=sys.stderr)
                    time.sleep(5)

                    logger.critical("Still alive! Sending KILL to all processes...")
                    subprocess.call(["/bin/kill", "-9", "-1"], stdout=sys.stderr)
        except Exception as e:
            logger.critical("Unexpected Exception: %s", str(e))
            listener.fail(sys.stdout)
            exit(1)
        else:
            listener.ok(sys.stdout)

if __name__ == '__main__':
    main(sys.argv[1:])
