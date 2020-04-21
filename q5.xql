
(:  
 : I pledge my honor that all parts of this project were done by me alone and
 : without collaboration with anybody else or using code from external sources.
 : CSE532 :Project 3
 : File name: q5.xql
 : Author: Name:Kushagra Pareek (SBU Id: 112551443)
 : Brief description: query5
 :)

xquery version "3.1";
declare namespace wc = "http://kush.pareek.com/wocoSchema";


declare function wc:directCompanyOwnership($cId1 as xs:string?,$cId2 as xs:string?)as xs:decimal?
{
    let $wc_ref := doc("woco.xml")/wc:woco
    let $pShares := $wc_ref/company[@cId=$cId1]/ownership/owns[@who=$cId2 and amount>0]/amount
    let $total := $wc_ref/company[@cId=$cId2]/shares
    return xs:decimal($pShares div $total)
};

declare function wc:indirectCompanyOwnership($cId1 as xs:string?, $cId2 as xs:string?, $percentage as xs:decimal?)
as xs:decimal?
{
    let $wc_ref := doc("woco.xml")/wc:woco
    let $dOwns := wc:directCompanyOwnership($cId1,$cId2)
    return (($percentage * $dOwns) + sum(
    for $cId3 in $wc_ref/company[@cId=$cId1]/ownership/owns[amount>0]/@cId
        let $inOwns := ($percentage * wc:directCompanyOwnership($cId1,$cId3))
        let $perControl := wc:indirectCompanyOwnership($cId3,$cId2,$inOwns)
    return $perControl
      ))
};

declare function wc:directPersonOwnership($pId as xs:string?,$cId as xs:string?)
as xs:decimal?
{
    let $wc_ref := doc("woco.xml")/wc:woco
    let $pShares := $wc_ref/person[@pId=$pId]/ownership/owns[@who=$cId and amount>0]/amount
    let $total := $wc_ref/company[@cId=$cId]/shares
    return xs:decimal($pShares div $total)
};

declare function wc:indirectPersonOwnership($pId as xs:string?, $cId as xs:string?, $percentage as xs:decimal?)
as xs:decimal?
{
    let $wc_ref := doc("woco.xml")/wc:woco
    let $dOwns := wc:directPersonOwnership($pId,$cId)
    return (($percentage * $dOwns) + sum(
    for $cId2 in  $wc_ref/person[@pId=$pId]/ownership/owns[amount>0]/@who
        let $inOwns := ($percentage * wc:directPersonOwnership($pId,$cId2))
        let $perControl := wc:indirectCompanyOwnership($cId2,$cId,$inOwns)
    return $perControl
      ))
};

<Query5>

{
let $wc_ref := doc("woco.xml")/wc:woco
for $p in $wc_ref/person
    for $c in $wc_ref/company
        let $percentage := round-half-to-even((xs:decimal(wc:indirectPersonOwnership($p/@pId,$c/@cId,1) * 100)),4)
        where $percentage>=10
    order by $p/name,$c/name
    return <entity>
            <person>{$p/name/text()}</person>
            <company>{$c/name/text()}</company>
            <percentage>{xs:decimal(sum($percentage))}</percentage>
          </entity>
}
</Query5>