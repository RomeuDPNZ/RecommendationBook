
package recBook;

import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.SecretKeyFactory;
import javax.crypto.SecretKey;
import javax.crypto.Cipher;

public class Cryptography {

	PBEParameterSpec pbeParamSpec;
	PBEKeySpec pbeKeySpec;
	SecretKeyFactory keyFac;
	SecretKey pbeKey;
	Cipher pbeCipher;

	byte[] salt = {
		(byte)0xc7, (byte)0x73, (byte)0x21, (byte)0x8c,
		(byte)0x7e, (byte)0xc8, (byte)0xee, (byte)0x99
	};

	int count = 20;

	final String staticKey = "RB19Key127RebornInSteel7DawnOfTheDead666ColdSteel";

	String password = "";

	public Cryptography(String password) throws Exception {
		String key = this.staticKey+password;
		pbeParamSpec = new PBEParameterSpec(salt, count);
		pbeKeySpec = new PBEKeySpec(key.toCharArray());
		keyFac = SecretKeyFactory.getInstance("PBEWithMD5AndDES");
		pbeKey = keyFac.generateSecret(pbeKeySpec);
		pbeCipher = Cipher.getInstance("PBEWithMD5AndDES");
	}

	public byte[] Encrypt(String text) throws Exception {
		pbeCipher.init(Cipher.ENCRYPT_MODE, pbeKey, pbeParamSpec);
		byte[] cleartext = text.getBytes();
		byte[] ciphertext = pbeCipher.doFinal(cleartext);
		return ciphertext;
	}

	public byte[] Decrypt(byte[] cipheredText) throws Exception {
		pbeCipher.init(Cipher.DECRYPT_MODE, pbeKey, pbeParamSpec);
		byte[] decipheredText = pbeCipher.doFinal(cipheredText);
		return decipheredText;
	}

}
