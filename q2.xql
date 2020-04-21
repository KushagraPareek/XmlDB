(:  
 : I pledge my honor that all parts of this project were done by me alone and
 : without collaboration with anybody else or using code from external sources.
 : CSE532 :Project 3
 : File name: q2.xql
 : Author: Name:Kushagra Pareek (SBU Id: 112551443)
 : Brief description: query2
 :)

xquery version "3.1";
declare namespace wc = "http://kush.pareek.com/wocoSchema";

<Query2>{
    
let $wc_ref := doc("woco.xml")/wc:woco
for $p in $wc_ref/person
  for $c in $wc_ref/company
    where $c[@cId = $p/ownership/owns[amount>0]/@who]
         let $worth := (($p/ownership/owns[@who = $c/@cId]/amount) * ($c/sharePrice))
group by $p         
return <person><name>{$p/name/text()}</name><worth>{xs:decimal(sum($worth))}</worth></person>
      
       
}
</Query2>           