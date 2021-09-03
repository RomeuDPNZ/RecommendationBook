
package recBook;

import java.util.Date;
import java.util.Locale;
import java.text.SimpleDateFormat;

public class RecBookDateFormat {

	public RecBookDateFormat() {

	}

	public String getDate(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("MMMMM d, yyyy", Locale.ENGLISH);
		return sdf.format(date).toString();
	}

	public String getDateFull(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("MMMMM d, yyyy HH:mm:ss", Locale.ENGLISH);
		return sdf.format(date).toString();
	}

}