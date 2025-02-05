{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, py4j
, pyarrow
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fnoj4RhUrbN/hgLeb8w6T5b9Xx4yO5u4MyXzhAjFqv0=";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    substituteInPlace setup.py \
      --replace py4j== 'py4j>='
  '';

  propagatedBuildInputs = [
    py4j
  ];

  passthru.optional-dependencies = {
    ml = [
      numpy
    ];
    mllib = [
      numpy
    ];
    sql = [
      numpy
      pandas
      pyarrow
    ];
  };

  # Tests assume running spark instance
  doCheck = false;

  pythonImportsCheck = [
    "pyspark"
  ];

  meta = with lib; {
    description = "Python bindings for Apache Spark";
    homepage = "https://github.com/apache/spark/tree/master/python";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ shlevy ];
  };
}
