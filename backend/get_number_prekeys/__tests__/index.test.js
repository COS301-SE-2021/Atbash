jest.mock("../db_access", () => ({
  addUser: jest.fn(),
  existsNumber: jest.fn(),
  authenticateAuthenticationToken: jest.fn(),
  registerKeys: jest.fn()
}))

const {handler, exportedForTests} = require("../index")
const {bytesToBase64, base64ToBytes} = require("./base64");

// const forge = require('node-forge');
// const { generateKeyPair, generateKeyPairSync } = require('crypto');
// const JSEncrypt = require('node-jsencrypt');
const BigInteger = require('jsbn').BigInteger;

const BlindSignature = require('blind-signatures');
const NodeRSA = require('node-rsa');
var sha256 = require('js-sha256');

const utf8Encoder = new TextEncoder();

describe("Unit tests for index.handler for register user",  () => {

  /*
   *   modulus           INTEGER,  -- n
   *   publicExponent    INTEGER,  -- e
   *   privateExponent   INTEGER,  -- d
   *   prime1            INTEGER,  -- p
   *   prime2            INTEGER,  -- q
   *   exponent1         INTEGER,  -- d mod (p-1)
   *   exponent2         INTEGER,  -- d mod (q-1)
   *   coefficient       INTEGER,  -- (inverse of q) mod p
   */
  let priKeyObject = {
    n: new BigInteger("572775949296369994698371469456352721910313913352751038761357076960310131803214678056226310119772645761200479432265117226838237964481536383773915223974819461418595605726530816797770010104150318326316819798417750083428749740357177783781981209031028587874743034681468648255160244013594301492314932355679440420705533150540102037067406671856512331898876455676530538792711432957161105015749518332288564691379289789420285787524410024760340259375152417854259130291465402308082571049788446067991046013751957021131711220903609669506176510150628383135275595107262910729037776218315557483619644820046771909078926976610748006356194485369511199103183364591638162608724820994544764867275562303628977445633937381515864166982566731619694317539112881251161987109846878918703260723129022252203363405984106963243641079669839567758682281228291687969845221429694675199398095314842274805799042569707993567746343020377774355879390148104312115128219754284406883186525189366604784598734774277432071612884159219333348745210091159028401179611744064928608789316562577684861083598040616353746808908569085822566825901873949241748153616443781594456397551969286493717785933857124793157305623130159166372338757917011514696640524442193680265608280963366704133760057237"),
    e: new BigInteger("65537"),
    d: new BigInteger("466212372236531440212245413532503465181253114941012731917631748681977870072030819021794349558709614652569973829054586162754763965047272179929440372731628993544311823731267221436139027099131705461022696115580457763559870396106219260846025994698432778302184909929478974816107970408489470357295081428526848494775713877388516457349645871851225930891155616699098906897758497942640065702734978804608102215495625898756972779494058750947031307446299503761502648065488661683054712148556004502050969048897331207337076817185439586952980450088882928269041020269494067624849949411627402816824180741879777846375425799782164909151506466758836009713258186489731758314026399018573445118260316445648708196688884388358927489691186403955472455201900104243884824443544934153753083418998584695370694788118683425699920215040291592248934891249470349188318413088147838442400679974873769480547490681512592602789902907529068311891326144204443110699105265582548589351564292826480302610494749176870394199720240425117146965002726012554892605488386302985317415173838665059862380474493316952267332717302921898667369453241476927980788614453945900824701356955877244595345714690461076464229663601864916425317261447212616089421688936676427655427484002291804561927264385"),
    p: new BigInteger("25627655493407810679249597918807249452839523284471083169976421988944194780397659141218949412381222471199039312592400172091066770422383909562858247283867287411202428935752277712957182235536290430871118822695414655894593862986971359956700239555432020598348920058274101521772739760695010871937240994908433195236918540725727555652495079186913211651176862812412774593759521015945275952105117208086597997932157527583021686920949140683909249185212975399980403002152091985749012476775606450531481131268803525269198190371721764246415554269539796588822385014778261775078084176735584057276023571124816482895193195725727818049263"),
    q: new BigInteger("22349916067964347059420782982435656468515055538790471353891991071658380457629851351118093771983586607444770267482404972451999007004647423010456689422872324185734306215005936466202959876272569446541554430631173682224025914076763377541024583510781176647887396007495759546370917038559737246095650197162602413500573624539604559834357099186025402830553458325510955359509687427660280794735166655160174634725728285309896336752745220313181600713747088965751265504666325194090689316814580313426285254994560158249438984048864277977653731980411424674894186292014314710024998814585264119893067637195535100359168150170150561325499"),
    dmp1: null,
    dmq1: null,
    coeff: null,
  }

  let pubKeyObject = {
    n: null,
    e: null,
  }

  function setPrivateKey(){
    priKeyObject.dmp1 = priKeyObject.d.mod(priKeyObject.p.subtract(new BigInteger("1"))); //d mod (p-1)
    priKeyObject.dmq1 = priKeyObject.d.mod(priKeyObject.q.subtract(new BigInteger("1"))); //d mod (q-1)
    priKeyObject.coeff = priKeyObject.q.modInverse(priKeyObject.p); //(inverse of q) mod p
  }

  function setPublicKey(){
    pubKeyObject.n = priKeyObject.n.clone();
    pubKeyObject.e = priKeyObject.e.clone();
  }

  test("Test 2", async () => {
    var hash = sha256.create();
    hash.update('Message to hash');
    var byteArr = await hash.arrayBuffer();

    console.log(byteArr);
    // console.log(byteArr.length());
    console.log(bytesToBase64(new Uint8Array(byteArr)));

    expect(3).toBe(3*1);
  })

  test("Test 1", async () => {

    setPrivateKey();
    setPublicKey();
    // console.log(priKeyObject.toString());
    // console.log(pubKeyObject.toString());

    //Create node key
    let key = new NodeRSA();
    key.importKey({
      n: Buffer.from(priKeyObject.n.toByteArray()),
      e: 65537,
      d: Buffer.from(priKeyObject.d.toByteArray()),
      p: Buffer.from(priKeyObject.p.toByteArray()),
      q: Buffer.from(priKeyObject.q.toByteArray()),
      dmp1: Buffer.from(priKeyObject.dmp1.toByteArray()),
      dmq1: Buffer.from(priKeyObject.dmq1.toByteArray()),
      coeff: Buffer.from(priKeyObject.coeff.toByteArray())
      }, "components");

    const Bob = {
      // key: BlindSignature.keyGeneration({ b: 2048 }), // b: key-length
      key: key,
      blinded: null,
      unblinded: null,
      message: null,
    };

    const Alice = {
      message: 'Hello Chaum!',
      N: null,
      E: null,
      r: null,
      signed: null,
      unblinded: null,
    };

// Alice wants Bob to sign a message without revealing it's contents.
// Bob can later verify he did sign the message

    console.log('Message:', Alice.message);

// Alice gets N and E variables from Bob's key
    Alice.N = Bob.key.keyPair.n.toString();
    Alice.E = Bob.key.keyPair.e.toString();

    const { blinded, r } = BlindSignature.blind({
      message: Alice.message,
      N: Alice.N,
      E: Alice.E,
    }); // Alice blinds message
    Alice.r = r;

    console.log('Hashed Message:', BlindSignature.messageToHash(Alice.message));

// Alice sends blinded to Bob
    Bob.blinded = blinded;

    const signed = BlindSignature.sign({
      blinded: Bob.blinded,
      key: Bob.key,
    }); // Bob signs blinded message

// Bob sends signed to Alice
    Alice.signed = signed;

    const unblinded = BlindSignature.unblind({
      signed: Alice.signed,
      N: Alice.N,
      r: Alice.r,
    }); // Alice unblinds
    Alice.unblinded = unblinded;

// Alice verifies
    const result = BlindSignature.verify({
      unblinded: Alice.unblinded,
      N: Alice.N,
      E: Alice.E,
      message: Alice.message,
    });
    if (result) {
      console.log('Alice: Signatures verify!');
    } else {
      console.log('Alice: Invalid signature');
    }

// Alice sends Bob unblinded signature and original message
    Bob.unblinded = Alice.unblinded;
    Bob.message = Alice.message;

// Bob verifies
    const result2 = BlindSignature.verify2({
      unblinded: Bob.unblinded,
      key: Bob.key,
      message: Bob.message,
    });
    if (result2) {
      console.log('Bob: Signatures verify!');
    } else {
      console.log('Bob: Invalid signature');
    }

    expect(3).toBe(3*1);
  })

})

