package recBook;

public class DetectOS {

	private static String OS = System.getProperty("os.name").toLowerCase();
	
	public static String getOS() {
		
		String os = "unix";
		
		if(OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") > 0 ) {
			os = "unix";
		} else if(OS.indexOf("mac") >= 0) {
			os = "mac";
		} else if(OS.indexOf("win") >= 0) {
			os = "win";
		} else if(OS.indexOf("sunos") >= 0) {
			os = "solaris";			
		}
		
		return os;
	}
	
}

