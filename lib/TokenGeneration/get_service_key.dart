import 'package:googleapis_auth/auth_io.dart';

class GetServiceKey{
  Future<String> getServerKeyToken() async{
    final scopes=[
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client=await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
      {
        "type": "service_account",
        "project_id": "chalo-kart",
        "private_key_id": "bde7e9b1ed93e226b0cdf19d9aaeda88d0518040",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCfFD1mQ5bXFVWQ\nTVmSI4s4pCjX8enCZjp1V/CNai4RHjVpMo8zFlOFsdR8espsvPljF4KzzonbJ4X+\nfNSKCU9JSHSYuX4CP65fgyDHeaXzxWsGWAOsmLEf/3FCOa59VQspykOMwTeYQNdu\niH4Mjpfymmrgxpr7d0pr9xdHg0Ikv09kXV2TJJSx1TV+S8kLthaeEDc/sf5q/KeA\nQm0BjEkNfWv5ZiLUaYrJTJr35A+jzfBE4OsvSmuETY8iaM+WlfJC35vKXx/aB8hB\nkakFe4eqorSCOT2TwZqrROJCr+UIq/zhWRKwwOJXTHpLjbWoD+/Qy55glFSqvXfn\n07R4LKY3AgMBAAECggEAAUobXna2RG9FpxnEx6gIJ6KsYz2fvM1upuCW88aA9T/h\nTmBV/TE1X/RMMz9FWcojhFKc6ZZD4OlLBspPCjbhDU8nBR44pajqA5fRs2L50Gzc\no/DCwS314358MOKUBehSizzVnt4SMPQ0IL430GePLosfhtJxGiszFlCxaGDOqOW9\nxc8Q3qJLGhIi9NqQDZAJv2SxeovSEYk+DU2047l5rnbYmv8AYt5GclK5c24VWixM\nW11scLAl9KL/OVn4PJlt53qX8PUCk3NcmSEwz5J7Qiuh7xxYzri03VzMHC0k1YLz\nD1peyEHaV6lymsevfisEp6upWX0v7nnLKHlaVmIBwQKBgQDQVMk+Kl6G1tOoC/Dn\nuAHgpfXwONBFKmLeEQESAqhBKs6bPL4jG24Xp1aVpMOErm9Icckw2m1jpWabX2ra\nUVQVYMGNVIiODIlyxpCdVo/8aYegACgCxdR1pI2UH218g3lybsYvE/3x7bXovTf8\nyCeq0KhNxz1p0RQuusGKuZrbdwKBgQDDenWZ6sF9Q40PeVvM1jci9Gccy+VLlsk8\nglSTgw7tOF7jh+AVChdJMtIthsmTuX3Zonn2nazzGceOgpdV5SdLJE2JRKudQqLy\ncVQWQn4VWGQC6nPHSBrrzLwMcqzJrIaCFZBTYDF5H7Fzm1u9vSEnqoz3gLhF4AUz\nIjKar427QQKBgQCLyTg29Cr1AtSGH20HrhnkaLc69oQYxLYOFw7GzO2kvFphI0LZ\nP6CBUpDwW9us/XZB/8dldkqL4AGXI1EJKCTpK0Dz2dK+rX7UepOyXtDCJvUP0MsI\nAUHrpfwxdVz7fSRSOi3UjO+KE1xJzBzzCkJDhTpI5fU5OUb3i+wtbxiPRQKBgE9+\nDjLgZ3zkKon/ZRiAiH17fC8Wr5E0qXMk4PX31usbAGNwzuxfZSbMNvJynKipRwdo\n7kYeysU1V5SZgKdaf8cr5SgMN+nEvnTvJy3CLnnJryoMY7bHmMMJR/Ob8q40raJa\n2I0/Uf8ap1QG+qDHN6Nk1NyViNpJhnPL1V5YQ7/BAoGAM/QLlFxb2zEtIHxiXZo8\na5Btv09DY/6xojbLFTc+9yUEBWNJom/IfosnsBEzH1h/OWvq5xhakSpCHU/WNYL/\n1wJW1EGAoMJSLVCpU4N7oY5vy6AHZYXN/jJ7bjSREGe28/kehFM5OTxuX96t4HB8\nCiIZx7NGZp1Uz7Oz5Wcde54=\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-fbsvc@chalo-kart.iam.gserviceaccount.com",
        "client_id": "113857918850540278675",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40chalo-kart.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }
      ,
    ),
    scopes,
    );
    final accessServerKey=client.credentials.accessToken.data;
    return accessServerKey;
  }
}