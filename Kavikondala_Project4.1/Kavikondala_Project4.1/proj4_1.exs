defmodule Project4 do

   if length(System.argv) != 2 do
     IO.puts("Please provide all required arguments")
     System.halt(0)
   end
   
[numNodes, numRequests] = System.argv()
  Simulator_Assign.main(String.to_integer(numNodes), String.to_integer(numRequests)) 
end
