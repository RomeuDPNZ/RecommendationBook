
package recBook;

import java.util.Random;
import java.lang.StringBuilder;
import java.security.SecureRandom;

public class PasswordGenerator {

	public PasswordGenerator() throws Exception {

	}

	public String getPassword() throws Exception {
		final String alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVXWZ";
		final int N = alphabet.length();

		Random r = new Random();

		StringBuilder sb = new StringBuilder(40);

		for (int i = 0; i < 8; i++) {
			sb.append(alphabet.charAt(r.nextInt(N)));
		}

		String sr = new String(sb);

		return sr;
	}

}
