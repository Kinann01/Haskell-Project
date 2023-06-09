import SubsetConstruction ( constructDFAFromNFA )
import TestWords ( simulateDFA )
import ReadWrite ( processDFA, showDFA, showFA)
import System.Environment ( getArgs )
import Types ( DFA, FiniteAutomaton )
import Minimization ( mainMinimize ) 

printDFA :: DFA -> IO ()
printDFA dfa = do
     mapM_ putStr (showDFA dfa)

printFA :: FiniteAutomaton -> IO()
printFA fa = do
     mapM_ putStr (showFA fa)

main :: IO ()
main = do
    args <- getArgs
    case args of
          ["-n", file] ->
               do
               content <- readFile file
               let dfa = constructDFAFromNFA (lines content)
               printDFA dfa

          ["-t", file] -> do
               content <- readFile file
               let dfa = processDFA (lines content)
               wordsToTest <- getContents
               let wordsList = lines wordsToTest
               mapM_ (\word -> putStrLn (word ++ ": " ++ if simulateDFA dfa word then "accepted" 
                    else "not accepted")) wordsList

          ["-m", file] ->
               do
               content <- readFile file
               let dfa = processDFA (lines content)
               printFA (mainMinimize dfa)

          _ -> putStrLn ("Argument needs to be provided!\nAvailable commands are:\n" 
                    ++ "1) runghc Main.hs -n file.nfa > file.dfa\n"
                    ++ "2) runghc Main.hs -t file.dfa < words.txt\n"
                    ++ "3) runghc Main.hs -m file.dfa > file_.dfa")