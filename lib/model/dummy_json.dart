String dummyHeightJSON = '''
{
    "success": "true",
    "message": "Operation successful",
    "status": "OK",
    "height": 7
}
''';

String dummyFromToJSON = '''
{
    "success": "true",
    "message": "Operation successful",
    "status": "OK",
    "from": 0,
    "to": 2,
    "headers": [
        {
            "voting_id": "GENESIS",
            "height": 0,
            "merkle_root": "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            "block_hash": "0x67df818365d4af91b8f47434118287781eebf39e49290aff9f3d9909ddc7a9c2",
            "prev_block_hash": "0x0000000000000000000000000000000000000000000000000000000000000000"
        },
        {
            "voting_id": "찐만두빵",
            "height": 1,
            "merkle_root": "0x595cc19946642bf5a6d48808faf13c51a658a9003f077e3864553a6c51483517",
            "block_hash": "0xf33231a148fd7a2269d221822fb17411cb27e192102b4e729f6ea8489c80022d",
            "prev_block_hash": "0x67df818365d4af91b8f47434118287781eebf39e49290aff9f3d9909ddc7a9c2"
        },
        {
            "voting_id": "잘되나",
            "height": 2,
            "merkle_root": "0xa33b29ec2567f22fab9658d2e6cd3e9d2e924c88ef993d668d545bcdeeb23352",
            "block_hash": "0xc20af33078f075429cf69668290a6cd4b1452dfaa34e15ba2662db0374b8932a",
            "prev_block_hash": "0xf33231a148fd7a2269d221822fb17411cb27e192102b4e729f6ea8489c80022d"
        }
    ]
}
''';

String dummyBlockJSON = '''
{
    "success": "true",
    "message": "Operation successful",
    "status": "OK",
    "block": {
        "header": {
            "voting_id": "캡스톤",
            "merkle_root": "6212ecde3029da870cd872b980861d420c35641c12f05495b112f20b17f7f562",
            "height": 5,
            "prev_block_hash": "1196d5a42ecce9f89f156ef9a15a94ef884c3a4e51f3e18097904ca1772988c1"
        },
        "block_hash": "14e9c7b96fb1a6901649459bb49a6d5305adcd4c7516e7664484e114562fe69e",
        "transactions": [
            {
                "hash": "114770d187e40dd976865ae168d9f2d19c8a51d6e00cb8889746a1644901b10a",
                "option": "예",
                "time_stamp": 1755785261021494476
            },
            {
                "hash": "8c7d8864ab8d12c63ba000cbd3f23b0a67ef6c3290403104b06c9be471dd0377",
                "option": "아니오",
                "time_stamp": 1755785270906682303
            },
            {
                "hash": "7bbd2264a245707506fc019ebdb514e47d1dc40591a65af8c9de3b4857c5bf14",
                "option": "아니오",
                "time_stamp": 1755785270923231933
            },
            {
                "hash": "daa5ec7cfbe8005556b819432883818a0deffefee103e706f6d1a72076825770",
                "option": "예",
                "time_stamp": 1755785280260582072
            }
        ]
    }
}
''';
