/**
 * The MIT License
 *
 * Copyright (c) 2010 VW
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.vwonderland.system
{
	/**
	 * Charset Data - Flash player에서 지원하는 문자 set 목록.
	 * <p>link - http://livedocs.adobe.com/flash/9.0_jp/ActionScriptLangRefV3/charset-codes.html</p>
	 * <p>link - http://www.iana.org/assignments/character-sets</p>
	 * <p>link - IANA(http://www.iana.org/assignments/character-sets)</p>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author Yukiya Okuda, alumican.net
	 * @since  21.07.2010
	 */
	public class CharSetData
	{
		
		/**
		* <p> 아랍어 (ASMO 708) </p>
		*/
		static public const ASMO_708:String = "ASMO-708";
		
		/**
		* <p> 아랍어 (DOS) </p>
		*/
		static public const DOS_720:String = "DOS-720";
		
		/**
		* <p> 아랍어 (ISO) </p>
		* <p> 별칭 : arabic, csISOLatinArabic, ECMA - 114, ISO_8859 - 6, ISO_8859 - 6 : 1987, iso - ir - 127 </p>
		*/
		static public const iso_8859_6:String = "iso-8859-6";
		
		/**
		* <p> 아랍어 (Macintosh) </p>
		*/
		static public const x_mac_arabic:String = "x-mac-arabic";
		
		/**
		* <p> 아랍어 (Windows) </p>
		* <p> 별칭 : cp1256 </p>
		*/
		static public const windows_1256:String = "windows-1256";
		
		/**
		* <p> 발트어 (DOS) </p>
		* <p> 별칭 : CP500 </p>
		*/
		static public const ibm775:String = "ibm775";
		
		/**
		* <p> 발트어 (ISO) </p>
		* <p> 별칭 : csISOLatin4, ISO_8859 - 4, ISO_8859 - 4 : 1988, iso - ir - 110, l4, latin4 </p>
		*/
		static public const iso_8859_4:String = "iso-8859-4";
		
		/**
		* <p> 발트어 (Windows) </p>
		*/
		static public const windows_1257:String = "windows-1257";
		
		/**
		* <p> 중앙 유럽어 (DOS) </p>
		* <p> 별칭 : cp852 </p>
		*/
		static public const ibm852:String = "ibm852";
		
		/**
		* <p> 중앙 유럽어 (ISO) </p>
		* <p> 별칭 : csISOLatin2, iso_8859 - 2, iso_8859 - 2 : 1987, iso8859 - 2, iso - ir - 101, l2, latin2 </p>
		*/
		static public const iso_8859_2:String = "iso-8859-2";
		
		/**
		* <p> 중앙 유럽어 (Macintosh) </p>
		*/
		static public const x_mac_ce:String = "x-mac-ce";
		
		/**
		* <p> 중앙 유럽어 (Windows) </p>
		* <p> 별칭 : x - cp1250 </p>
		*/
		static public const windows_1250:String = "windows-1250";
		
		/**
		* <p> 중국어 간체 (EUC) </p>
		* <p> 별칭 : x - euc - cn </p>
		*/
		static public const EUC_CN:String = "EUC-CN";
		
		/**
		* <p> 중국어 간체 (GB2312) </p>
		* <p> 별칭 : chinese, CN - GB, csGB2312, csGB231280, csISO58GB231280, GB_2312 - 80, GB231280, GB2312 - 80, GBK, iso - ir - 58 </p>
		*/
		static public const gb2312:String = "gb2312";
		
		/**
		* <p> 중국어 간체 (HZ) </p>
		*/
		static public const hz_gb_2312:String = "hz-gb-2312";
		
		/**
		* <p> 중국어 간체 (Macintosh) </p>
		*/
		static public const x_mac_chinesesimp:String = "x-mac-chinesesimp";
		
		/**
		* <p> 중국어 번체 (Big5) </p>
		* <p> 별칭 : cn - big5, csbig5, xx - big5 </p>
		*/
		static public const big5:String = "big5";
		
		/**
		* <p> 중국어 번체 (CNS) </p>
		*/
		static public const x_Chinese_CNS:String = "x-Chinese-CNS";
		
		/**
		* <p> 중국어 번체 (Eten) </p>
		*/
		static public const x_Chinese_Eten:String = "x-Chinese-Eten";
		
		/**
		* <p> 중국어 번체 (Macintosh) </p>
		*/
		static public const x_mac_chinesetrad:String = "x-mac-chinesetrad";
		
		/**
		* <p> 키릴 자모 (DOS) </p>
		* <p> 별칭 : ibm866 </p>
		*/
		static public const cp866:String = "cp866";
		
		/**
		* <p> 키릴 자모 (ISO) </p>
		* <p> 별칭 : csISOLatin5, csISOLatinCyrillic, cyrillic, ISO_8859 - 5, ISO_8859 - 5 : 1988, iso - ir - 144, l5 </p>
		*/
		static public const iso_8859_5:String = "iso-8859-5";
		
		/**
		* <p> 키릴 자모 (KOI8 - R) </p>
		* <p> 별칭 : csKOI8R, koi, koi8, koi8r </p>
		*/
		static public const koi8_r:String = "koi8-r";
		
		/**
		* <p> 키릴 자모 (KOI8 - U) </p>
		* <p> 별칭 : koi8 - ru </p>
		*/
		static public const koi8_u:String = "koi8-u";
		
		/**
		* <p> 키릴 자모 (Macintosh) </p>
		*/
		static public const x_mac_cyrillic:String = "x-mac-cyrillic";
		
		/**
		* <p> 키릴 자모 (Windows) </p>
		* <p> 별칭 : x - cp1251 </p>
		*/
		static public const windows_1251:String = "windows-1251";
		
		/**
		* <p> Europa </p>
		*/
		static public const x_Europa:String = "x-Europa";
		
		/**
		* <p> 독일어 (IA5) </p>
		*/
		static public const x_IA5_German:String = "x-IA5-German";
		
		/**
		* <p> 그리스어 (DOS) </p>
		*/
		static public const ibm737:String = "ibm737";
		
		/**
		* <p> 그리스어 (ISO) </p>
		* <p> 별칭 : csISOLatinGreek, ECMA - 118, ELOT_928, greek, greek8, ISO_8859 - 7, ISO_8859 - 7 : 1987, iso - ir - 126 </p>
		*/
		static public const iso_8859_7:String = "iso-8859-7";
		
		/**
		* <p> 그리스어 (Macintosh) </p>
		*/
		static public const x_mac_greek:String = "x-mac-greek";
		
		/**
		* <p> 그리스어 (Windows) </p>
		*/
		static public const windows_1253:String = "windows-1253";
		
		/**
		* <p> 그리스어, Modern (DOS) </p>
		*/
		static public const ibm869:String = "ibm869";
		
		/**
		* <p> 히브리어 (DOS) </p>
		*/
		static public const DOS_862:String = "DOS-862";
		
		/**
		* <p> 히브리어 (ISO - Logical) </p>
		* <p> 별칭 : logical </p>
		*/
		static public const iso_8859_8_i:String = "iso-8859-8-i";
		
		/**
		* <p> 히브리어 (ISO - Visual) </p>
		* <p> 별칭 : csISOLatinHebrew, hebrew, ISO_8859 - 8, ISO_8859 - 8 : 1988, ISO - 8859 - 8, iso - ir - 138, visual </p>
		*/
		static public const iso_8859_8:String = "iso-8859-8";
		
		/**
		* <p> 히브리어 (Macintosh) </p>
		*/
		static public const x_mac_hebrew:String = "x-mac-hebrew";
		
		/**
		* <p> 히브리어 (Windows) </p>
		* <p> 별칭 : ISO_8859 - 8 - I, ISO - 8859 - 8, visual </p>
		*/
		static public const windows_1255:String = "windows-1255";
		
		/**
		* <p> IBM EBCDIC (아랍어) </p>
		*/
		static public const x_EBCDIC_Arabic:String = "x-EBCDIC-Arabic";
		
		/**
		* <p> IBM EBCDIC (키릴 자모 러시아어) </p>
		*/
		static public const x_EBCDIC_CyrillicRussian:String = "x-EBCDIC-CyrillicRussian";
		
		/**
		* <p> IBM EBCDIC (키릴 자모 세르비아어 - 불가 리아어) </p>
		*/
		static public const x_EBCDIC_CyrillicSerbianBulgarian:String = "x-EBCDIC-CyrillicSerbianBulgarian";
		
		/**
		* <p> IBM EBCDIC (덴마크 - 노르웨이) </p>
		*/
		static public const x_EBCDIC_DenmarkNorway:String = "x-EBCDIC-DenmarkNorway";
		
		/**
		* <p> IBM EBCDIC (덴마크 - 노르웨이 - 유럽) </p>
		*/
		static public const x_ebcdic_denmarknorway_euro:String = "x-ebcdic-denmarknorway-euro";
		
		/**
		* <p> IBM EBCDIC (핀란드 - 스웨덴) </p>
		*/
		static public const x_EBCDIC_FinlandSweden:String = "x-EBCDIC-FinlandSweden";
		
		/**
		* <p> IBM EBCDIC (핀란드 - 스웨덴 - 유럽) </p>
		* <p> 별칭 : X - EBCDIC - France </p>
		*/
		static public const x_ebcdic_finlandsweden_euro:String = "x-ebcdic-finlandsweden-euro";
		
		/**
		* <p> IBM EBCDIC (프랑스 - 유럽) </p>
		*/
		static public const x_ebcdic_france_euro:String = "x-ebcdic-france-euro";
		
		/**
		* <p> IBM EBCDIC (독일) </p>
		*/
		static public const x_EBCDIC_Germany:String = "x-EBCDIC-Germany";
		
		/**
		* <p> IBM EBCDIC (독일 - 유럽) </p>
		*/
		static public const x_ebcdic_germany_euro:String = "x-ebcdic-germany-euro";
		
		/**
		* <p> IBM EBCDIC (Greek Modern) </p>
		*/
		static public const x_EBCDIC_GreekModern:String = "x-EBCDIC-GreekModern";
		
		/**
		* <p> IBM EBCDIC (그리스어) </p>
		*/
		static public const x_EBCDIC_Greek:String = "x-EBCDIC-Greek";
		
		/**
		* <p> IBM EBCDIC (히브리어) </p>
		*/
		static public const x_EBCDIC_Hebrew:String = "x-EBCDIC-Hebrew";
		
		/**
		* <p> IBM EBCDIC (아이슬란드어) </p>
		*/
		static public const x_EBCDIC_Icelandic:String = "x-EBCDIC-Icelandic";
		
		/**
		* <p> IBM EBCDIC (아이슬란드어 - 유럽) </p>
		*/
		static public const x_ebcdic_icelandic_euro:String = "x-ebcdic-icelandic-euro";
		
		/**
		* <p> IBM EBCDIC (국제 - 유럽) </p>
		*/
		static public const x_ebcdic_international_euro:String = "x-ebcdic-international-euro";
		
		/**
		* <p> IBM EBCDIC (이탈리아) </p>
		*/
		static public const x_EBCDIC_Italy:String = "x-EBCDIC-Italy";
		
		/**
		* <p> IBM EBCDIC (이탈리아 - 유럽) </p>
		*/
		static public const x_ebcdic_italy_euro:String = "x-ebcdic-italy-euro";
		
		/**
		* <p> IBM EBCDIC (일본어, 일본어 가타 카나) </p>
		*/
		static public const x_EBCDIC_JapaneseAndKana:String = "x-EBCDIC-JapaneseAndKana";
		
		/**
		* <p> IBM EBCDIC (일본어, 일본어 - 라틴 문자) </p>
		*/
		static public const x_EBCDIC_JapaneseAndJapaneseLatin:String = "x-EBCDIC-JapaneseAndJapaneseLatin";
		
		/**
		* <p> IBM EBCDIC (일본어, US - 캐나다) </p>
		*/
		static public const x_EBCDIC_JapaneseAndUSCanada:String = "x-EBCDIC-JapaneseAndUSCanada";
		
		/**
		* <p> IBM EBCDIC (일본어 가타 카나) </p>
		*/
		static public const x_EBCDIC_JapaneseKatakana:String = "x-EBCDIC-JapaneseKatakana";
		
		/**
		* <p> IBM EBCDIC (한국어, 일본어 Extended) </p>
		*/
		static public const x_EBCDIC_KoreanAndKoreanExtended:String = "x-EBCDIC-KoreanAndKoreanExtended";
		
		/**
		* <p> IBM EBCDIC (한국어 Extended) </p>
		*/
		static public const x_EBCDIC_KoreanExtended:String = "x-EBCDIC-KoreanExtended";
		
		/**
		* <p> IBM EBCDIC (다국어 라틴어 -2) </p>
		*/
		static public const CP870:String = "CP870";
		
		/**
		* <p> IBM EBCDIC (중국어 간체) </p>
		*/
		static public const x_EBCDIC_SimplifiedChinese:String = "x-EBCDIC-SimplifiedChinese";
		
		/**
		* <p> IBM EBCDIC (스페인) </p>
		*/
		static public const X_EBCDIC_Spain:String = "X-EBCDIC-Spain";
		
		/**
		* <p> IBM EBCDIC (스페인 - 유럽) </p>
		*/
		static public const x_ebcdic_spain_euro:String = "x-ebcdic-spain-euro";
		
		/**
		* <p> IBM EBCDIC (태국어) </p>
		*/
		static public const x_EBCDIC_Thai:String = "x-EBCDIC-Thai";
		
		/**
		* <p> IBM EBCDIC (번체) </p>
		*/
		static public const x_EBCDIC_TraditionalChinese:String = "x-EBCDIC-TraditionalChinese";
		
		/**
		* <p> IBM EBCDIC (터키어 라틴 문자 -5) </p>
		*/
		static public const CP1026:String = "CP1026";
		
		/**
		* <p> IBM EBCDIC (터키어) </p>
		*/
		static public const x_EBCDIC_Turkish:String = "x-EBCDIC-Turkish";
		
		/**
		* <p> IBM EBCDIC (UK) </p>
		*/
		static public const x_EBCDIC_UK:String = "x-EBCDIC-UK";
		
		/**
		* <p> IBM EBCDIC (UK - 유럽) </p>
		*/
		static public const x_ebcdic_uk_euro:String = "x-ebcdic-uk-euro";
		
		/**
		* <p> IBM EBCDIC (US - 캐나다) </p>
		*/
		static public const ebcdic_cp_us:String = "ebcdic-cp-us";
		
		/**
		* <p> IBM EBCDIC (US - 캐나다 - 유럽) </p>
		*/
		static public const x_ebcdic_cp_us_euro:String = "x-ebcdic-cp-us-euro";
		
		/**
		* <p> 아이슬란드어 (DOS) </p>
		*/
		static public const ibm861:String = "ibm861";
		
		/**
		* <p> 아이슬란드어 (Macintosh) </p>
		*/
		static public const x_mac_icelandic:String = "x-mac-icelandic";
		
		/**
		* <p> ISCII 아삼어 </p>
		*/
		static public const x_iscii_as:String = "x-iscii-as";
		
		/**
		* <p> ISCII 벵골어 </p>
		*/
		static public const x_iscii_be:String = "x-iscii-be";
		
		/**
		* <p> ISCII 데바 나 가리어 문자 </p>
		*/
		static public const x_iscii_de:String = "x-iscii-de";
		
		/**
		* <p> ISCII 구자라트어 </p>
		*/
		static public const x_iscii_gu:String = "x-iscii-gu";
		
		/**
		* <p> ISCII 칸나다어 </p>
		*/
		static public const x_iscii_ka:String = "x-iscii-ka";
		
		/**
		* <p> ISCII 말라얄람어 </p>
		*/
		static public const x_iscii_ma:String = "x-iscii-ma";
		
		/**
		* <p> ISCII 오리야어 </p>
		*/
		static public const x_iscii_or:String = "x-iscii-or";
		
		/**
		* <p> ISCII 펀잡어 </p>
		*/
		static public const x_iscii_pa:String = "x-iscii-pa";
		
		/**
		* <p> ISCII 타밀어 </p>
		*/
		static public const x_iscii_ta:String = "x-iscii-ta";
		
		/**
		* <p> ISCII 텔루구어 </p>
		*/
		static public const x_iscii_te:String = "x-iscii-te";
		
		/**
		* <p> 일본어 (EUC) </p>
		* <p> 별칭 : csEUCPkdFmtJapanese, Extended_UNIX_Code_Packed_Format_for_Japanese, x - euc, x - euc - jp </p>
		*/
		static public const euc_jp:String = "euc-jp";
		
		/**
		* <p> 일본어 (JIS 1 바이트 가타가나 가능 - SO / SI) </p>
		* <p> 별칭 : _iso - 2022 - jp $ SIO </p>
		*/
		static public const iso_2022_jp:String = "iso-2022-jp";
		
		/**
		* <p> 일본어 (JIS 1 바이트 가타가나 가능) </p>
		* <p> 별칭 : _iso - 2022 - jp </p>
		*/
		static public const csISO2022JP:String = "csISO2022JP";
		
		/**
		* <p> 일본어 (Macintosh) </p>
		*/
		static public const x_mac_japanese:String = "x-mac-japanese";
		
		/**
		* <p> 일본어 (Shift - JIS) </p>
		* <p> 별칭 : csShiftJIS, csWindows31J, ms_Kanji, shift - jis, x - ms - cp932, x - sjis </p>
		*/
		static public const shift_jis:String = "shift_jis";
		
		/**
		* <p> 한국어 </p>
		* <p> 별칭 : csKSC56011987, euc - kr, iso - ir - 149, korean, ks_c_5601, ks_c_5601_1987, ks_c_5601 - 1989, KSC_5601, KSC5601 </p>
		*/
		static public const ks_c_5601_1987:String = "ks_c_5601-1987";
		
		/**
		* <p> 한국어 (EUC) </p>
		* <p> 별칭 : csEUCKR </p>
		*/
		static public const euc_kr:String = "euc-kr";
		
		/**
		* <p> 한국어 (ISO) </p>
		* <p> 별칭 : csISO2022KR </p>
		*/
		static public const iso_2022_kr:String = "iso-2022-kr";
		
		/**
		* <p> 한국어 (Johab) </p>
		*/
		static public const Johab:String = "Johab";
		
		/**
		* <p> 한국어 (Macintosh) </p>
		*/
		static public const x_mac_korean:String = "x-mac-korean";
		
		/**
		* <p> 라틴어 3 (ISO) </p>
		* <p> 별칭 : csISO, Latin3, ISO_8859 - 3, ISO_8859 - 3 : 1988, iso - ir - 109, l3, latin3 </p>
		*/
		static public const iso_8859_3:String = "iso-8859-3";
		
		/**
		* <p> 라틴어 9 (ISO) </p>
		* <p> 별칭 : csISO, Latin9, ISO_8859 - 15, l9, latin9 </p>
		*/
		static public const iso_8859_15:String = "iso-8859-15";
		
		/**
		* <p> 노르웨 이어 (IA5) </p>
		*/
		static public const x_IA5_Norwegian:String = "x-IA5-Norwegian";
		
		/**
		* <p> OEM 미국 </p>
		* <p> 별칭 : 437, cp437, csPC8, CodePage437 </p>
		*/
		static public const IBM437:String = "IBM437";
		
		/**
		* <p> 스웨덴어 (IA5) </p>
		*/
		static public const x_IA5_Swedish:String = "x-IA5-Swedish";
		
		/**
		* <p> 태국어 (Windows) </p>
		* <p> 별칭 : DOS - 874, iso - 8859 - 11, TIS - 620 </p>
		*/
		static public const windows_874:String = "windows-874";
		
		/**
		* <p> 터키어 (DOS) </p>
		*/
		static public const ibm857:String = "ibm857";
		
		/**
		* <p> 터키어 (ISO) </p>
		* <p> 별칭 : csISO, Latin5, ISO_8859 - 9, ISO_8859 - 9 : 1989, iso - ir - 148, l5, latin5 </p>
		*/
		static public const iso_8859_9:String = "iso-8859-9";
		
		/**
		* <p> 터키어 (Macintosh) </p>
		*/
		static public const x_mac_turkish:String = "x-mac-turkish";
		
		/**
		* <p> 터키어 (Windows) </p>
		* <p> 별칭 : ISO_8859 - 9, ISO_8859 - 9 : 1989, iso - 8859 - 9, iso - ir - 148, latin5 </p>
		*/
		static public const windows_1254:String = "windows-1254";
		
		/**
		* <p> Unicode </p>
		* <p> 별칭 : utf - 16 </p>
		*/
		static public const unicode:String = "unicode";
		
		/**
		* <p> Unicode (Big - Endian) </p>
		*/
		static public const unicodeFFFE:String = "unicodeFFFE";
		
		/**
		* <p> Unicode (UTF - 7) </p>
		* <p> 별칭 : csUnicode11UTF7, unicode - 1 - 1 - utf - 7, x - unicode - 2 - 0 - utf - 7 </p>
		*/
		static public const utf_7:String = "utf-7";
		
		/**
		* <p> Unicode (UTF - 8) </p>
		* <p> 별칭 : unicode - 1 - 1 - utf - 8, unicode - 2 - 0 - utf - 8, x - unicode - 2 - 0 - utf - 8 </p>
		*/
		static public const utf_8:String = "utf-8";
		
		/**
		* <p> US - ASCII </p>
		* <p> 별칭 : ANSI_X3.4 - 1968, ANSI_X3.4 - 1986, ascii, cp367, csASCII, IBM367, ISO_646.irv : 1991, ISO646 - US, iso - ir - 6us </p>
		*/
		static public const us_ascii:String = "us-ascii";
		
		/**
		* <p> 베트남어 (Windows) </p>
		*/
		static public const windows_1258:String = "windows-1258";
		
		/**
		* <p> 서유럽어 (DOS) </p>
		*/
		static public const ibm850:String = "ibm850";
		
		/**
		* <p> 서유럽어 (IA5) </p>
		*/
		static public const x_IA5:String = "x-IA5";
		
		/**
		* <p> 서유럽어 (ISO) </p>
		* <p> 별칭 : cp819, csISO, Latin1, ibm819, iso_8859 - 1, iso_8859 - 1 : 1987, iso8859 - 1, iso - ir - 100, l1, latin1 </p>
		*/
		static public const iso_8859_1:String = "iso-8859-1";
		
		/**
		* <p> 서유럽어 (Macintosh) </p>
		*/
		static public const macintosh:String = "macintosh";
		
		/**
		* <p> 서유럽어 (Windows) </p>
		* <p> 별칭 : ANSI_X3.4 - 1968, ANSI_X3.4 - 1986, ascii, cp367, cp819, csASCII, IBM367, ibm819, ISO_646.irv : 1991, iso_8859 - 1, iso_8859 - 1 : 1987, ISO646 - US, iso8859 - 1, iso - 8859 - 1, iso - ir - 100, iso - ir - 6, latin1, us, us - ascii, x - ansi </p>
		*/
		static public const Windows_1252:String = "Windows -1252";
		

	}
}