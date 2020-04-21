xquery version "3.1";

(:  
 : I pledge my honor that all parts of this project were done by me alone and
 : without collaboration with anybody else or using code from external sources.
 : CSE532 :Project 3
 : File name: q3.xql
 : Author: Name:Kushagra Pareek (SBU Id: 112551443)
 : Brief description: query3
 :)




declare namespace wc = "http://kush.pareek.com/wocoSchema";

<Query3>{
let $wc_ref := doc("woco.xml")/wc:woco
for $c in $wc_ref/company
for $p in $wc_ref/person
where $p[@pId = $c/board/boardMember/@member and $p/ownership/owns/amount = max($p/ownership/owns[@who = $c/@cId and amount>0]/amount)]
 
return <max><company>{$c/name/text()}</company><person>{$p/name/text()}</person></max>
}
</Query3>   


