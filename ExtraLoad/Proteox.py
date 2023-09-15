from autobahn.asyncio.component import Component
from autobahn.asyncio.component import run
import sys

# Read in user / router details
USER = sys.argv[2]
USER_SECRET = sys.argv[3]
URL = sys.argv[4]
REALM = sys.argv[5]

comp = Component(
    transports=URL,
    realm=REALM,
    authentication={
        'wampcra' : {
            'authid' : USER,
            'secret' : USER_SECRET
        }
    }
)

@comp.on_join
async def joined(session, details):
    try:
        resp = await session.call(sys.argv[1])
        print(resp.results)
        session.leave()
        sys.exit(0)
    except Exception as e:
        print("Proteox error: {}".format(e))
        session.leave()
        sys.exit(1)

if __name__ == "__main__":
    run([comp])
