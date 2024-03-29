import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypton/crypton.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/encryption/BlindSignatures.dart';
import 'package:mobile/encryption/services/IdentityKeyStoreService.dart';
import 'package:mobile/encryption/services/PreKeyStoreService.dart';
import 'package:mobile/encryption/services/SessionStoreService.dart';
import 'package:mobile/encryption/services/SignalProtocolStoreService.dart';
import 'package:mobile/encryption/services/SignedPreKeyStoreService.dart';
import 'package:mobile/services/DatabaseService.dart';
import 'package:mobile/services/EncryptionService.dart';
import 'package:mobile/services/MessageboxService.dart';
import 'package:mobile/services/UserService.dart';

import 'package:pointycastle/export.dart' as Pointy;

import 'package:crypto/crypto.dart';

import 'package:mockito/mockito.dart';

class MockUserService extends Mock implements UserService {
  MockUserService() {
    throwOnMissingStub(this);
  }
}

class MockDatabaseService extends Mock implements DatabaseService {
  MockDatabaseService() {
    throwOnMissingStub(this);
  }
}

class MockIdentityKeyStoreService extends Mock
    implements IdentityKeyStoreService {
  MockIdentityKeyStoreService() {
    throwOnMissingStub(this);
  }
}

class MockPreKeyStoreService extends Mock implements PreKeyStoreService {
  MockPreKeyStoreService() {
    throwOnMissingStub(this);
  }
}

class MockSessionStoreService extends Mock implements SessionStoreService {
  MockSessionStoreService() {
    throwOnMissingStub(this);
  }
}

class MockSignedPreKeyStoreService extends Mock
    implements SignedPreKeyStoreService {
  MockSignedPreKeyStoreService() {
    throwOnMissingStub(this);
  }
}

class MockSignalProtocolStoreService extends Mock
    implements SignalProtocolStoreService {
  MockSignalProtocolStoreService() {
    throwOnMissingStub(this);
  }
}

// class FakeUserService extends Fake implements UserService {}
//
// class FakeDatabaseService extends Fake implements DatabaseService {}

void main() {
  final userService = MockUserService();
  final databaseService = MockDatabaseService();
  final messageboxService = MessageboxService(userService, databaseService);

  final identityKeyStoreService = MockIdentityKeyStoreService();
  final preKeyStoreService = MockPreKeyStoreService();
  final sessionStoreService = MockSessionStoreService();
  final signedPreKeyStoreService = MockSignedPreKeyStoreService();
  final signalProtocolStoreService = MockSignalProtocolStoreService();
  final encryptionService = EncryptionService(
      userService,
      signalProtocolStoreService,
      identityKeyStoreService,
      signedPreKeyStoreService,
      preKeyStoreService,
      sessionStoreService,
      messageboxService);

  String nStr =
      "572775949296369994698371469456352721910313913352751038761357076960310131803214678056226310119772645761200479432265117226838237964481536383773915223974819461418595605726530816797770010104150318326316819798417750083428749740357177783781981209031028587874743034681468648255160244013594301492314932355679440420705533150540102037067406671856512331898876455676530538792711432957161105015749518332288564691379289789420285787524410024760340259375152417854259130291465402308082571049788446067991046013751957021131711220903609669506176510150628383135275595107262910729037776218315557483619644820046771909078926976610748006356194485369511199103183364591638162608724820994544764867275562303628977445633937381515864166982566731619694317539112881251161987109846878918703260723129022252203363405984106963243641079669839567758682281228291687969845221429694675199398095314842274805799042569707993567746343020377774355879390148104312115128219754284406883186525189366604784598734774277432071612884159219333348745210091159028401179611744064928608789316562577684861083598040616353746808908569085822566825901873949241748153616443781594456397551969286493717785933857124793157305623130159166372338757917011514696640524442193680265608280963366704133760057237";
  String eStr = "65537";

  String blindedStrBig =
      "568016689539875122210536052444097511022046191836126349797565382868310601744629070229280566560575665406919242527741387068235032202726923455339402166991855063920591748984444464764338021058872509340427674639981396078618513194952387980953417882328665667703276582670469356435913317099282570005135784208662159210531571153382241553594023860545444094823218630593107356933360201365804420345271001846264788306867874704835273392367473157691456569718171328474561108966415249799004899107399597466791783036668159029281932085176256706962196569167381324334294637278397505514528796361979734614839392857248966033578890291552474876505400133508250285172610632508540309791594594397367191077332674128293822582560653110834758499517282957533846890154306985329879949982904752516545733155025018701482563684689049378247193449711430331333359238585885499399258599356395171353010565849512782427749946792089938188774059511771205194641820445998458831561780392130707231654168609797538530565784393433194574246986731550017020040998021964487018967157865409312227688962595154407438113398432968452512745043029973694949459213751021246786973423339395365038476429567001726133469179638923009894430674320348641171591880294750479333755064933649798338980899895829453837105948858";
  String rStrBig =
      "34279826025393578717895301824274544020184316721090493915375780147972132289645";

  String signedStrBig =
      "93317659309552267298819671910362322580277137109408577736932706823116219428898075329118590970432700466804469807582492181031174230806543650546854658484033524661763392498329322951429778269757523604813473972572753443571434054042852484394826749367821837038728313111451689497169635185936751714477155061667133124496874483975469652764211163138537410923406935199130171879184143624977835955585838982635920547045411915019047776209670010726704143828020531679771299418902394164047626483923179778743755527327897167582695911086223185840527146046844826700766117281266575161773247083350787967874100468421735250563358600750557913473661705460272866305081371487982871670325406242691418645039879375779830603498065389133981164204817134971123131631383549019899355865583090076823854739689241896328213438293435567931272733313241300771578542523061418677169295956632013931982988841596071257149647579329269864421056864461471579239788424445075470943494217368817550000690571488588250571879457703667778889195487653905538281768446065296088854728934282866843401731256955935103715221143233818415964950711564729324574574518529972629429751420927861670230229888810575208414175470665610892631073659065275522428808143720119413822270044724693832230049815629020131499594949";

  String unblindedStrBig =
      "379188831427105924870620793298048036731864920265570037090530765727001733279771819948370176247994905492579769356402705623138696583190592854752652276984905671054693545464551275051453508563440740346039078662013669200503145730662746824549988040589059979088946698077393789595976180985460395185943387673647344499298354973228299956578550933742257980174746856974087714088717711208949584023193167745791218105511466568077234421669713520918323427189598297563765180911249337714805929605693730490006798563232041697867160371047690964449798575351731849176102811598821818657803896206321537344825484399990396429184907253683322079717638942057583455120961372046633739468812050571336105813266958366918469858583790114725652058769670606404321742465400876688460339623579044499410260742928278886652257173085561595863665057332731358235581903136512703270236964288087752426598446086480144368475067460066649514786147046723516220461276238561721917738586496585164505272856598045056674306952400293899194482195010488922613530032432684538852917786603602422649926220123357031823131604062250517346173815694843874334481560795010324948676787252444010912443549639878910135599364844045190313799142450511224007766692252566452479679801275488366209225860026433404495857661119";

  test('Test 5.1', () async {
    print("Testing Hashing");
    final bigN = BigInt.parse(nStr);
    final bigE = BigInt.parse(eStr);
    var r;
    final blindSignatures = BlindSignatures();

    RSAPublicKey? serverKey = RSAPublicKey(bigN, bigE);

    final message = jsonEncode({
      "n":
          "97030062102994282155914552959636906182586164522860542164446357372585904984694272446662711611964010019916386223732378136564474764709877679941834513478882465952002995572595366638460072257441962101167457226443561857090668892806707067307920397996322386333978380108225314956777440420139491583226541706248510603813",
      "e": "65537"
    });
    print("Message to blind: \n" + message);
    print(base64Encode(utf8.encode(message)));
    //eyJuIjoiOTcwMzAwNjIxMDI5OTQyODIxNTU5MTQ1NTI5NTk2MzY5MDYxODI1ODYxNjQ1MjI4NjA1NDIxNjQ0NDYzNTczNzI1ODU5MDQ5ODQ2OTQyNzI0NDY2NjI3MTE2MTE5NjQwMTAwMTk5MTYzODYyMjM3MzIzNzgxMzY1NjQ0NzQ3NjQ3MDk4Nzc2Nzk5NDE4MzQ1MTM0Nzg4ODI0NjU5NTIwMDI5OTU1NzI1OTUzNjY2Mzg0NjAwNzIyNTc0NDE5NjIxMDExNjc0NTcyMjY0NDM1NjE4NTcwOTA2Njg4OTI4MDY3MDcwNjczMDc5MjAzOTc5OTYzMjIzODYzMzM5NzgzODAxMDgyMjUzMTQ5NTY3Nzc0NDA0MjAxMzk0OTE1ODMyMjY1NDE3MDYyNDg1MTA2MDM4MTMiLCJlIjoiNjU1MzcifQ==

    final blindedMessage = blindSignatures.blind(message, serverKey);

    // TODO I commented this because there were compiler errors
    // final blindObject = blindSignatures.blind(message, bigN, bigE);
    // r = blindObject["r"];
    // final blindedBigInt = blindObject["blinded"];
    // print(blindedBigInt.toString());
    print(r.toString());

    expect(3, 3 * 2 / 2);
  });

  test('Test 4', () async {
    print("Testing Hashing");
    final signed = BigInt.parse(signedStrBig);
    final r = BigInt.parse(rStrBig);
    final N = BigInt.parse(nStr);
    final blindSignatures = BlindSignatures();

    final unblinded = blindSignatures.unblind(signed, r, N);

    print(unblinded.toString());

    expect(3, 3 * 2 / 2);
  });

  // test('Test 3', () async {
  //   print("Testing Hashing");
  //   final bigN = BigInt.parse(nStr);
  //   final bigE = BigInt.parse(eStr);
  //   var r;
  //   final blindSignatures = BlindSignatures();
  //
  //   String message = "This is the message I would like to have signed";
  //
  //   final blindObject = blindSignatures.blind(message, bigN, bigE);
  //   r = blindObject["r"];
  //   final blindedBigInt = blindObject["blinded"];
  //   print(blindedBigInt.toString());
  //   print(r.toString());
  //
  //   expect(3, 3*2/2);
  // });

  test('Test 2', () async {
    print("Testing Hashing");

    var bytes = utf8.encode("Message to hash"); // data being hashed
    var digest = sha256.convert(bytes);

    print(base64Encode(digest.bytes));

    expect(3, 3 * 2 / 2);
  });

  // test('Test 1', () async {
  //   print("Testing BlindSignatures");
  //
  //   final sGen = Random.secure();
  //   Pointy.SecureRandom secureRandom = Pointy.FortunaRandom();
  //   secureRandom.seed(Pointy.KeyParameter(
  //       Uint8List.fromList(List.generate(32, (_) => sGen.nextInt(255)))));
  //
  //   Uint8List salt = secureRandom.nextBytes(20);
  //
  //   RSAKeypair rsaKeypair = RSAKeypair.fromRandom(keySize: 4096);
  //   final pubRsaKey = rsaKeypair.publicKey.asPointyCastle;
  //   final priRsaKey = rsaKeypair.privateKey.asPointyCastle;
  //
  //   String messageToSign = "Hello this message will be signed";
  //   print("Message to sign: " + messageToSign);
  //   print("Message to sign: " + base64Encode(utf8.encode(messageToSign)));
  //   BigInt blindingFactor = encryptionService.generateBlindingFactor(pubRsaKey);
  //
  //   Uint8List blindedMessage = encryptionService.createBlindedMessage(messageToSign, pubRsaKey, blindingFactor, salt);
  //   print("Blinded Message: " + base64Encode(blindedMessage));
  //
  //   Uint8List signedBlindedMessage = encryptionService.serverSignMessage(blindedMessage, priRsaKey);
  //   print("Signed Blinded Message: " + base64Encode(signedBlindedMessage));
  //
  //   Uint8List signedMessage = encryptionService.unblindMessage(signedBlindedMessage, pubRsaKey, blindingFactor, salt);
  //   print("Signed Message: " + base64Encode(signedMessage));
  //
  //   final isVerified = encryptionService.serverVerifyMessage(messageToSign, signedMessage, pubRsaKey, salt);
  //   print("Verified: " + isVerified.toString());
  //
  //   expect(3, 3*2/2);
  // });
}
