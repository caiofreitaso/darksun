/<h1/ { printable = 1 }
/<div class="footer"/ { printable = 0 }
printable {
	gsub(/\/wilder/, "", $0);
	gsub(/psychic warrior/, "war mind", $0);
	gsub(/Psychic warrior/, "War mind", $0);
	gsub(/Psychic Warrior/, "War mind", $0);
	gsub(/Long \(400 ft\. \+ ?40 ?ft.\/level\)/, "Long (120 m + 12 m/level)", $0);
	gsub(/Medium \(100 ft\. \+ ?10 ?ft.\/level\)/, "Medium (30 m + 3 m/level)", $0);
	gsub(/Close \(25 ft\. \+ ?5 ?ft.\/2 levels\)/, "Close (7.5 m + 1.5 m/2 levels)", $0);
	gsub(/’/, "'", $0);
	gsub(/%/, "\\%", $0);

	if ($0 ~ /<h1/) {
		gsub(/(^\s+|)<[^>]+>/,"",$0);
		print "\\Psionic{" $0 "}{" tolower($0) "}"
	} else if ($0 ~ /<h1/) {
		gsub(/(^\s+|)<[^>]+>/,"",$0);
		print "{" $0 "}"
	} else if ($0 ~ /<h4/) {
		gsub(/(^\s+|)<[^>]+>/,"",$0);
		print "{" $0 "}"
	} else if ($0 ~ /\/td/) {
		gsub(/(^\s+|)<[^>]+>/,"",$0);
		print "\t" $0 "\\\\"
	} else if ($0 ~ /<table/) {
		print "{"
	} else if ($0 ~ /<\/?tr>|<p>|^$/) {
	} else if ($0 ~ /<h6/) {
		gsub(/(^\s+|)<[^>]+>/,"",$0);
		print "\t\\textit{" $0 "}:"
	} else if ($0 ~ /<\/table/) {
		print "}\n{"
	# } else if ($0 ~ //) {
	} else {
		gsub(/(^\s+|)<[^>]+>/,"",$0);
		if ($0 ~ /:/) {
			print "\t\\textbf{" $0 "}"
		} else {
			print
		}
	}
}
END { print "}" }