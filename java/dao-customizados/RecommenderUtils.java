
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class RecommenderUtils {

	public RecommenderUtils() {

	}

	public String getAge(Date birthDate) {
		Calendar now = Calendar.getInstance();
		Calendar birth = Calendar.getInstance();

		birth.setTime(birthDate);

		Integer age = now.get(Calendar.YEAR) - birth.get(Calendar.YEAR);

		if(now.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
			--age;
		}

		return age.toString();
	}

	public String getDeathAge(Date birthDate, Date deathDate) {
		Calendar death = Calendar.getInstance();
		Calendar birth = Calendar.getInstance();

		birth.setTime(birthDate);
		death.setTime(deathDate);

		Integer age = death.get(Calendar.YEAR) - birth.get(Calendar.YEAR);

		if(death.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
			--age;
		}

		return age.toString();
	}

}