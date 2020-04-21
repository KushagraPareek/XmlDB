(:  
 : I pledge my honor that all parts of this project were done by me alone and
 : without collaboration with anybody else or using code from external sources.
 : CSE532 :Project 3
 : File name: q1.xql
 : Author: Name:Kushagra Pareek (SBU Id: 112551443)
 : Brief description: query1
 :)

xquery version "3.1";

declare namespace wc = "http://kush.pareek.com/wocoSchema";

<Query1>{
let $wc_ref := doc("woco.xml")/wc:woco
for $c in $wc_ref/company
where  $c/ownedby/owns/amount > 0 and   $c/ownedby/owns[amount > 0]/@who = $c/board/boardMember/@member 
return <company>{$c/name/text()}</company>
}
</Query1>      