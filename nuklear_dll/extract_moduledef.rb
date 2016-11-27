# coding: utf-8
# Generates 'nuklear.def' (nuklear module DEFinition file for Windows DLL).
$export_apis = []

File.open("../nuklear/nuklear.h", "r") { |nuklear_header|
  nuklear_header_lines = nuklear_header.readlines
  nk_apis = nuklear_header_lines.select { |line| line =~ /^NK_API/ && line =~ /;$/} # ex.) NK_API int nk_init_default(struct nk_context*, const struct nk_user_font*);
  nk_apis.each { |nk_api|
    match_data = /(\w+)\(/.match(nk_api) # ex.) nk_init_default(
    api_name = match_data.captures[0] # # ex.) nk_init_default
    $export_apis << api_name
  }
}

File.open("./nuklear.def", "w") { |nuklear_def|
  nuklear_def << "LIBRARY\tnuklear\n"
  nuklear_def << "EXPORTS\n"
  $export_apis.each { |nk_api|
    nuklear_def << "\t#{nk_api}\n"
  }
}
