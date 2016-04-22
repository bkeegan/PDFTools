<# 
.SYNOPSIS 
	Searches for specified text in all PDFs located within a specified folder.
.DESCRIPTION 
	Searches for specified text in all PDFs located within a specified folder. Requires iTextSharp library
.NOTES 
    File Name  : Search-TextInPDF.ps1
    Author     : Brenton keegan - brenton.keegan@gmail.com 
    Licenced under GPLv3  
	Dependant iTextSharp library licensed under AGPLv3
.LINK 
	https://github.com/bkeegan/PDFTools
    License: http://www.gnu.org/copyleft/gpl.html
	https://github.com/itext/itextsharp
	iTextSharp Library: https://github.com/itext/itextsharp
.EXAMPLE 
	Search-TextInPDF -dll "C:\Library\itextsharp.dll" -p "C:\PDFs" -s "text to find"
#> 


Function Search-TextInPDF
{
	[cmdletbinding()]
	Param
	(
		[parameter(Mandatory=$true)]
		[alias("dll")] 
		[string]$pathtoItextDLL,
		
		[parameter(Mandatory=$true)]
		[alias("p")] 
		[string]$pathtoPDFs,
		
		[parameter(Mandatory=$true)]
		[alias("s")] 
		[string]$searchTerm
	)
	
	#imports
	Add-Type -Path $pathtoItextDLL
	
	$pdfFiles = Get-ChildItem $pathtoPDFs
	foreach ($pdfFile in $pdfFiles)
	{
	 $pdfReader = New-Object iTextSharp.text.pdf.pdfreader -ArgumentList $pdfFile.FullName
	 For ($i = 1; $i -le $pdfReader.NumberOfPages; $i++)
        {
			$pdfParser = New-Object iTextSharp.text.pdf.parser.SimpleTextExtractionStrategy
			$currentPage = [iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($pdfReader, $i, $pdfParser)
			Foreach ($line in $currentPage.Split("`r`n"))
			{
				$i++
				If ($line -match $searchTerm)
				{
					Write-Host "Match found on line $i of file: $($pdfFile.Fullname)" -foregroundcolor "Green"
					$line 
				}
			}
		}
		$pdfReader.Close()
	}
}
