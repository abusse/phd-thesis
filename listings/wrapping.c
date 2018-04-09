/**
 * \brief Writes the C string pointed by format to the kernel log.
 *
 * Writes the C string pointed by format to the kernel log. If format includes 
 * format specifiers (subsequences beginning with %), the additional arguments 
 * following format are formatted and inserted in the resulting string replacing
 * their respective specifiers. Refer to ISO 9899 Section 7.21.6.3 for details.
 *
 * @param format C string that contains the text to be written to the kernel log
 * @param ... (additional arguments) Depending on the format string, the 
              function may expect a sequence of additional arguments.
 * @return On success, the total number of characters written is returned.
 */
#ifndef os_printf
	int os_printf(const char* format, ...);
#endif