BEGIN {
  FS = " ";
  origin_dirs[0] = "$ORIGIN/";
  origin_dirs[1] = "$ORIGIN/lib/";
  origin_dirs[2] = "$ORIGIN/../lib/";
  origin_dirs_cnt = 3;
}

{
  for (i = 1; i <= NF; ++i) {
    s[cnt++] = $i"/";
  }
}

END {
  printf ("#define SYSTEM_DIRS \\\n");

  printf ("  \"%s\"", s[0]);

  for (i = 1; i < cnt; ++i) {
    printf (" \"\\0\" \"%s\"", s[i]);
  }

  printf ("\n\n");

  printf ("#define SYSTEM_DIRS_LEN \\\n");

  printf ("  %d", length (s[0]));
  m = length (s[0]);

  for (i = 1; i < cnt; ++i) {
    printf (", %d", length(s[i]));
    if (length(s[i]) > m) {
      m = length(s[i]);
    }
  }

  printf ("\n\n");

  printf ("#define SYSTEM_DIRS_MAX_LEN\t%d\n", m);
  
  printf ("\n\n\n");
  
  printf ("#define ORIGIN_BASED_DIRS \\\n");

  printf ("  \"%s\"", origin_dirs[0]);

  for (i = 1; i < origin_dirs_cnt; ++i) {
    printf (" \"\\0\" \"%s\"", origin_dirs[i]);
  }

  printf ("\n\n");

  printf ("#define ORIGIN_BASED_DIRS_LEN \\\n");

  printf ("  %d", length(origin_dirs[0]));
  m = length (origin_dirs[0]);

  for (i = 1; i < origin_dirs_cnt; ++i) {
    printf (", %d", length(origin_dirs[i]));
    if (length(origin_dirs[i]) > m) {
      m = length(origin_dirs[i]);
    }
  }

  printf ("\n\n");

  printf ("#define ORIGIN_BASED_DIRS_MAX_LEN\t%d\n", m);
  
  printf ("\n\n\n");
}


