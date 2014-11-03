require "formula"

class ClosureLinter < Formula
  homepage "https://developers.google.com/closure/utilities/"
  url "https://closure-linter.googlecode.com/files/closure_linter-2.3.13.tar.gz"
  sha1 "71763adfd097dbf2d456db3b1b77ebeb0ba60664"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "python-gflags" do
    url "https://pypi.python.org/packages/source/p/python-gflags/python-gflags-2.0.tar.gz"
    sha1 "1529a1102da2fc671f2a9a5e387ebabd1ceacbbf"
  end

  def install
    ENV["PYTHONPATH"] = libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}", "--single-version-externally-managed", "--record=install.txt" }
    end

    system "python", "setup.py", "install", "--prefix=#{libexec}", "--single-version-externally-managed", "--record=install.txt"

    bin.install Dir[libexec/"bin/*js*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.js").write("var test = 1;\n")
    system "#{bin}/gjslint", "test.js"
    system "#{bin}/fixjsstyle", "test.js"
  end
end
