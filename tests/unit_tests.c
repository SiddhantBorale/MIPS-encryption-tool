/*
DO NOT CHANGE THE CONTENTS OF THIS FILE IN CASE A NEW VERSION IS DISTRIBUTED.
PUT YOUR OWN TEST CASES IN student_tests.c
*/

#include "unit_tests.h"

static char test_log_outfile[100];

void expect_outfile_matches(char *name) {
    char cmd[500];
    sprintf(cmd, "diff %s/%s.txt %s ", TEST_INPUT_DIR, name, test_log_outfile);
    int err = system(cmd);
    cr_expect_eq(err, 0, "The output was not what was expected (diff exited with status %d).\n", WEXITSTATUS(err));
}

void execute_test(char *test_name) {
    char *mars_jar = "./MarsFall2020.jar";
    assert(access(mars_jar, F_OK) == 0);
    char cmd[500];
    sprintf(test_log_outfile, "%s/%s.txt", TEST_OUTPUT_DIR, test_name);
    sprintf(cmd, "ulimit -f 50; ulimit -t %d; java -jar MarsFall2020.jar tests/%s.asm --noGui --main -q -n 100000 >> %s 2>&1", TEST_TIMEOUT, test_name, test_log_outfile);
    system(cmd); 
    expect_outfile_matches(test_name);
}

TestSuite(base_tests, .timeout=TEST_TIMEOUT, .disabled=false);

Test(base_tests, null_cipher_decrypt_test01) {
    execute_test("null_cipher_decrypt_test01");
}
Test(base_tests, null_cipher_decrypt_test02) {
    execute_test("null_cipher_decrypt_test02");
}

Test(base_tests, transposition_cipher_decrypt_test01) {
    execute_test("transposition_cipher_decrypt_test01");
}
Test(base_tests, transposition_cipher_decrypt_test02) {
    execute_test("transposition_cipher_decrypt_test02");
}

Test(base_tests, decrypt_test01) {
    execute_test("decrypt_test01");
}
Test(base_tests, decrypt_test02) {
    execute_test("decrypt_test02");
}

