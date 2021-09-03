<%@ page import="java.util.HashMap" %>

<%!

public class TestLocales {

	HashMap<String, Long> locales;

	public TestLocales() {

		locales = new HashMap<String, Long>();

		locales.put("pt_BR",15l);

		locales.put("sq_AL", 3l);
		locales.put("ar_DZ", 4l);
		locales.put("ca_AD", 5l);
		locales.put("pt_AO", 6l);
		locales.put("en_AG", 7l);
		locales.put("es_AR", 8l);

/*
		locales.put("ar_AE: Arabic - United Arab Emirates	
		locales.put("ar_BH: Arabic - Bahrain
		locales.put("ar_EG: Arabic - Egypt
		locales.put("ar_IN: Arabic - India	
		locales.put("ar_IQ: Arabic - Iraq
		locales.put("ar_JO: Arabic - Jordan	
		locales.put("ar_KW: Arabic - Kuwait
		locales.put("ar_LB: Arabic - Lebanon	
		locales.put("ar_LY: Arabic - Libya
		locales.put("ar_MA: Arabic - Morocco	
		locales.put("ar_OM: Arabic - Oman
		locales.put("ar_QA: Arabic - Qatar	
		locales.put("ar_SA: Arabic - Saudi Arabia
		locales.put("ar_SD: Arabic - Sudan	
		locales.put("ar_SY: Arabic - Syria
		locales.put("ar_TN: Arabic - Tunisia	
		locales.put("ar_YE: Arabic - Yemen
		locales.put("be_BY: Belarusian - Belarus	
		locales.put("bg_BG: Bulgarian - Bulgaria
		locales.put("ca_ES: Catalan - Spain	
		locales.put("cs_CZ: Czech - Czech Republic
		locales.put("da_DK: Danish - Denmark	
		locales.put("de_AT: German - Austria
		locales.put("de_BE: German - Belgium	
		locales.put("de_CH: German - Switzerland
		locales.put("de_DE: German - Germany	
		locales.put("de_LU: German - Luxembourg
		locales.put("en_AU: English - Australia
		locales.put("en_CA: English - Canada
		locales.put("en_GB: English - United Kingdom	
		locales.put("en_IN: English - India
		locales.put("en_NZ: English - New Zealand	
		locales.put("en_PH: English - Philippines
		locales.put("en_US: English - United States	
		locales.put("en_ZA: English - South Africa
		locales.put("en_ZW: English - Zimbabwe	
		locales.put("es_BO: Spanish - Bolivia	
		locales.put("es_CL: Spanish - Chile
		locales.put("es_CO: Spanish - Columbia	
		locales.put("es_CR: Spanish - Costa Rica
		locales.put("es_DO: Spanish - Dominican Republic	
		locales.put("es_EC: Spanish - Ecuador
		locales.put("es_ES: Spanish - Spain	
		locales.put("es_GT: Spanish - Guatemala
		locales.put("es_HN: Spanish - Honduras	
		locales.put("es_MX: Spanish - Mexico
		locales.put("es_NI: Spanish - Nicaragua	
		locales.put("es_PA: Spanish - Panama
		locales.put("es_PE: Spanish - Peru	
		locales.put("es_PR: Spanish - Puerto Rico
		locales.put("es_PY: Spanish - Paraguay	
		locales.put("es_SV: Spanish - El Salvador
		locales.put("es_US: Spanish - United States	
		locales.put("es_UY: Spanish - Uruguay
		locales.put("es_VE: Spanish - Venezuela	
		locales.put("et_EE: Estonian - Estonia
		locales.put("eu_ES: Basque - Basque	
		locales.put("fi_FI: Finnish - Finland
		locales.put("fo_FO: Faroese - Faroe Islands	
		locales.put("fr_BE: French - Belgium
		locales.put("fr_CA: French - Canada	
		locales.put("fr_CH: French - Switzerland
		locales.put("fr_FR: French - France	
		locales.put("fr_LU: French - Luxembourg
		locales.put("gl_ES: Galician - Spain	
		locales.put("gu_IN: Gujarati - India
		locales.put("he_IL: Hebrew - Israel	
		locales.put("hi_IN: Hindi - India
		locales.put("hr_HR: Croatian - Croatia	
		locales.put("hu_HU: Hungarian - Hungary
		locales.put("id_ID: Indonesian - Indonesia	
		locales.put("is_IS: Icelandic - Iceland
		locales.put("it_CH: Italian - Switzerland	
		locales.put("it_IT: Italian - Italy
		locales.put("ja_JP: Japanese - Japan	
		locales.put("ko_KR: Korean - Republic of Korea
		locales.put("lt_LT: Lithuanian - Lithuania	
		locales.put("lv_LV: Latvian - Latvia
		locales.put("mk_MK: Macedonian - FYROM	
		locales.put("mn_MN: Mongolia - Mongolian
		locales.put("ms_MY: Malay - Malaysia	
		locales.put("nb_NO: Norwegian(Bokmål) - Norway
		locales.put("nl_BE: Dutch - Belgium	
		locales.put("nl_NL: Dutch - The Netherlands
		locales.put("no_NO: Norwegian - Norway	
		locales.put("pl_PL: Polish - Poland
		locales.put("pt_BR: Portugese - Brazil	
		locales.put("pt_PT: Portugese - Portugal
		locales.put("ro_RO: Romanian - Romania	
		locales.put("ru_RU: Russian - Russia
		locales.put("ru_UA: Russian - Ukraine	
		locales.put("sk_SK: Slovak - Slovakia
		locales.put("sl_SI: Slovenian - Slovenia	
		locales.put("sr_YU: Serbian - Yugoslavia	
		locales.put("sv_FI: Swedish - Finland
		locales.put("sv_SE: Swedish - Sweden	
		locales.put("ta_IN: Tamil - India
		locales.put("te_IN: Telugu - India	
		locales.put("th_TH: Thai - Thailand
		locales.put("tr_TR: Turkish - Turkey	
		locales.put("uk_UA: Ukrainian - Ukraine
		locales.put("ur_PK: Urdu - Pakistan	
		locales.put("vi_VN: Vietnamese - Viet Nam
		locales.put("zh_CN: Chinese - China	
		locales.put("zh_HK: Chinese - Hong Kong
		locales.put("zh_TW: Chinese - Taiwan Province of China

*/

	}

	public Long getCountry(String locale) {
		Long country = 0l;
		if(locales.containsKey(locale)) {
			if(locales.get(locale) != null) {
				country = locales.get(locale);
			}
		} else {
			country = locales.get("WWE");
		}
		return country;
	}

}

%>