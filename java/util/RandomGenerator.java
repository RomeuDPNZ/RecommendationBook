
package recBook;

import java.util.Random;
import java.lang.StringBuilder;
import java.security.SecureRandom;

public class RandomGenerator {

	public RandomGenerator() throws Exception {

	}

	public String getLettersAndNumbers() throws Exception {
		final String alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVXWZ";
		final int N = alphabet.length();

		Random r = new Random();

		StringBuilder sb = new StringBuilder(40);

		for (int i = 0; i < 40; i++) {
			sb.append(alphabet.charAt(r.nextInt(N)));
		}

		String sr = new String(sb);

		return sr;
	}

	public String getBytes() throws Exception {
		SecureRandom srandom = new SecureRandom();

		byte bytes[] = new byte[40];

		srandom.nextBytes(bytes);

		String sBytes = new String(bytes);

		return sBytes;
	}

}
