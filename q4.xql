(:  
 : I pledge my honor that all parts of this project were done by me alone and
 : without collaboration with anybody else or using code from external sources.
 : CSE532 :Project 3
 : File name: q4.xql
 : Author: Name:Kushagra Pareek (SBU Id: 112551443)
 : Brief description: query4
 :)

xquery version "3.1";

declare namespace wc = "http://kush.pareek.com/wocoSchema";

<Query4>
{
let $wc_ref := doc("woco.xml")/wc:woco
for $c1 in $wc_ref/company
    for $c2 in $wc_ref/company[@cId != $c1/@cId and industries/industry=$c1/industries/industry]
        where every $cp in $wc_ref/person[@pId=$c2/board/boardMember/@member]/ownership/owns
        satisfies (
    $wc_ref/person[@pId=$c1/board/boardMember/@member]/ownership/owns[@who=$cp/@who]/amount >= xs:integer($cp/amount)
           )
return <company>
       <company1>{$c1/name/text()}</company1>
       <company2>{$c2/name/text()}</company2>
       </company>
}
</Query4>