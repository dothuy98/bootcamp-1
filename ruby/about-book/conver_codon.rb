def convert_codon(genome: ) 
  codon_table = { 'UUU' => 'F', 'CUA' => 'L', 'AGU' => 'S', }
  anticodon = { 'A' => 'U', 'T' => 'A', 'G' => 'C', 'C' => 'G', }
  genome.gsub!(/./, anticodon).gsub!(/.../, codon_table)
end
  
pair1 = "GATTCAAAA"
puts convert_codon(genome: pair1)
