# dafScanner_2.0

## Usage

1.  <noah explains>  
2. 2ocr: dafReader2.m reads cut up pics from 1blockScanner/results and outputs ocr and line information to gemara, rashi, and tosfos folders.  
3. 3combine: combine1.py reads ocr and line info and merge.json from gemara, rashi, tosfos folders. Combines taht info creating myDaf.txt in gemara folder.  
4. 4HTML: gemaraMaster.py takes stats.txt (from gemara, rashi, tosfos) and myDaf.txt and creates a html with the proper line sizes.  