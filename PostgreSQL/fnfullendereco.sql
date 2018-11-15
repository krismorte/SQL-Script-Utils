CREATE OR REPLACE FUNCTION fnFullEndereco(idEndereco varchar)
RETURNS varchar AS $endereco$
declare
   endereco varchar;
   endTemp varchar;
   idPai varchar; 
BEGIN
   	select descricao ,enderecopai into endTemp,idPai from endereco where id =idEndereco;
	endereco := endTemp;
	select descricao ,enderecopai into endTemp,idPai from endereco where id =idPai;
    endereco := concat(endTemp,'.',endereco);
    select descricao ,enderecopai into endTemp,idPai from endereco where id =idPai;
    endereco := concat(endTemp,'.',endereco);
    select descricao ,enderecopai into endTemp,idPai from endereco where id =idPai;
    endereco := concat(endTemp,'.',endereco);
   RETURN endereco;
END;
$endereco$ LANGUAGE plpgsql;