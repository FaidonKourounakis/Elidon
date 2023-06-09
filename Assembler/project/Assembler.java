package project;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.*;
import java.util.Random;


public class Assembler {
    private final String[] HexValues = new String[]{"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"};
    private final List<InstructionFormat> InstructionsList;
    private final Map<String, Integer> Registers;
    private final ArrayList<String> AssemblyCodeBits;
    private final Map<String, Integer> Labels;

    public List<String> stringList;

    public Assembler() throws Exception {
        InstructionsList = new ArrayList<>();
        Registers = new HashMap<>();
        AssemblyCodeBits = new ArrayList<>();
        stringList = new ArrayList<>();
        Labels= new HashMap<>();


        Initialize();
    }

    public void Run() throws Exception {

        String folderPath = "..\\Assembly Code";
        File folder = new File(folderPath);
        File[] listOfFiles = folder.listFiles();
        if (listOfFiles != null) {
            for (File file : listOfFiles) {
                if (file.isFile()) {


                    try (Scanner scanner = new Scanner(new File(file.getPath()))) {

                        List<String> stringList2=new ArrayList<>();
                        String aux="";
                        while(scanner.hasNextLine()) {
                            String tmp= scanner.nextLine();
                            if (!(tmp.startsWith("#") || tmp.length()==0)){
                                if(!tmp.contains(":")) {
                                    Instruction Instruction;
                                    Instruction = ParseInstruction(tmp);
                                    stringList2.add(aux+Assemble(Instruction));
                                }
                            }
                        }
                        String folderPathwrite = "..\\Machine Code";
                        String fileName = file.getName();
                        Path filePath = Paths.get(folderPathwrite, fileName);

                        try {
                            Files.deleteIfExists(filePath);

                            Files.newBufferedWriter(Paths.get(folderPathwrite, fileName), StandardOpenOption.CREATE)
                                    .append(String.join("\n", stringList2))
                                    .close();
                            System.out.println("File has been written successfully!");
                        } catch (IOException e) {
                            System.err.println("An error occurred while writing the file.");
                            e.printStackTrace();
                        }


                    } catch (FileNotFoundException e) {
                        throw new FileNotFoundException("File not found at: " + e.getMessage());
                    } catch (Exception e) {
                        throw new Exception("Unhandled exception at: " + e.getMessage());
                    }

                    System.out.println("File: " + file.getName());
                }
            }
        } else {
            System.out.println("No files found in the directory.");
        }







    }

    public Instruction ParseInstruction(String instruction) throws Exception {
        Instruction Instruction = new Instruction();
        try {
            String[] operands = instruction.replaceAll(",", "").split(" ");
            if (operands.length == 4) {
                Instruction.Mnemonic = operands[0];
                Instruction.Argument0 = operands[1];
                Instruction.Argument1 = operands[2];
                Instruction.Argument2 = operands[3];
            } else if (operands.length == 3) { //mI type or wI type or a branch
                if (operands[2].contains("(")) {
                    String rs = operands[2].replace("(", " ");
                    rs = rs.replace(")", "");
                    String[] tmp = rs.split(" ");

                    Instruction.Mnemonic = operands[0];
                    Instruction.Argument0 = operands[1];
                    Instruction.Argument1 = tmp[0];
                    Instruction.Argument2 = tmp[1];
                } else {
                    Instruction.Mnemonic = operands[0];
                    Instruction.Argument0 = operands[1];
                    Instruction.Argument1 = operands[2];


                }


            } else if (operands.length == 2) {
                if(Labels.containsKey(operands[1])){
                    Instruction.Mnemonic = operands[0];
                    Instruction.Argument0 = Integer.toString(Labels.get(operands[1]));
                }
                else {
                    Instruction.Mnemonic = operands[0];
                    Instruction.Argument0 = operands[1];
                    Instruction.Argument1 = "0";
                    Instruction.Argument2 = "0";
                }



            }

        } catch (Exception e) {
            throw new InputMismatchException("Invalid instruction/ set of operands");
        }
        return Instruction;
    }

    public String Assemble(Instruction instruction) {
        for (InstructionFormat instructionFormat: InstructionsList) {
            if (instructionFormat.Mnemonic.equals(instruction.Mnemonic)) {
                System.out.print(instructionFormat.InstructionType);
                switch (instructionFormat.InstructionType) {
                    case R:
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(instructionFormat.Opcode))); // Opcode has 4 bits
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(Registers.get(instruction.Argument0)))); // rd has 4 bits

                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(Registers.get(instruction.Argument2)))); // rs has 4 bits
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(Registers.get(instruction.Argument1)))); // rt has 4 bits
                        break;
                    case I:
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(instructionFormat.Opcode))); // Opcode has 4 bits
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(Registers.get(instruction.Argument0)))); // rs has 4 bits
                        //InsertToAssemblyCodeBits(PrependBits(5, String.valueOf(Registers.get(instruction.Argument0)))); // rt has 5 bits
                        InsertToAssemblyCodeBits(PrependBits(8, String.valueOf(instruction.Argument1))); // immediate has 8 bits
                        break;
                    case J:
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(instructionFormat.Opcode))); // Opcode has 4 bits
                        InsertToAssemblyCodeBits(PrependBits(12, String.valueOf(instruction.Argument0))); // adress has 12 bits
                        break;
                    case mI:
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(instructionFormat.Opcode))); // Opcode has 4 bits
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(Registers.get(instruction.Argument0)))); // rs has 4 bits
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(Registers.get(instruction.Argument2)))); // rt has 4 bits
                        InsertToAssemblyCodeBits(PrependBits(4, String.valueOf(instruction.Argument1))); // immediate
                        break;
                    default:
                        throw new RuntimeException("Unhandled instruction type");
                }
            }
        }
        if (AssemblyCodeBits.size() > 0) {
            ShowAssemblyCodeBits();
            String Code = Arrays.stream(AssemblyCodeBits.stream().toArray(String[]::new)).reduce((a, b) -> a + b).get();

            AssemblyCodeBits.clear();

            //System.out.println(Code);
            return Code;
        }
        throw new NullPointerException("Instruction not implemented/ not compatible");
    }

    private void ShowAssemblyCodeBits() {
        for (String binary: AssemblyCodeBits) {
            System.out.print(" " + binary);
        }
        System.out.println();
    }

    private String[] GetAssemblyCodeBits() {
        String assemblyBits = Arrays.stream(AssemblyCodeBits.stream().toArray(String[]::new)).reduce((a, b) -> a + b).get();
        String[] _assemblyBits = new String[8];
        Arrays.fill(_assemblyBits, 0, 8, "");
        int i = 0, j = 0, spaceAfter = 4;
        for (char ch: assemblyBits.toCharArray()) {
            System.out.print(ch);
            _assemblyBits[j] += ch;
            i++;
            if (i % spaceAfter == 0) {
                System.out.print(" ");
                j++;
            }
        }
        System.out.println();
        AssemblyCodeBits.clear();
        return _assemblyBits;
    }

    private String InstructionPrompt() {
        Scanner scanner = new Scanner(System.in);
        System.out.print(">> ");
        return scanner.nextLine();
    }

    private String PrependBits(int n, String value) {
        int intVal = Integer.parseInt(value);
        value = Integer.toBinaryString(intVal);
        while (value.length() < n) {
            value = '0' + value;
        }
        return value;
    }

    private void InsertToAssemblyCodeBits(String value) {
        AssemblyCodeBits.add(value);
    }




    private void Initialize() throws Exception {
        try (Scanner scanner = new Scanner(new File("InstructionSet.csv"))) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                String[] assemblyCode = line.split(",");
                InstructionFormat instructionFormat = new InstructionFormat();
                instructionFormat.Mnemonic = assemblyCode[0].trim();
                switch (assemblyCode[1].trim()) {
                    case "R":
                        instructionFormat.InstructionType = InstructionType.R;
                        instructionFormat.Funct = 0;
                        instructionFormat.Opcode = new BigInteger(assemblyCode[2].trim(), 16).byteValue();

                        break;
                    case "I":
                        instructionFormat.InstructionType = InstructionType.I;
                        instructionFormat.Opcode = new BigInteger(assemblyCode[2].trim(), 16).byteValue();
                        break;
                    case "mI":
                        instructionFormat.InstructionType = InstructionType.mI;
                        instructionFormat.Opcode = new BigInteger(assemblyCode[2].trim(), 16).byteValue();
                        break;
                    case "J":
                        instructionFormat.InstructionType = InstructionType.J;
                        instructionFormat.Opcode = new BigInteger(assemblyCode[2].trim(), 16).byteValue();

                        break;
                    default:
                        throw new RuntimeException("Unhandled instruction type: " + assemblyCode[1]);
                }
                InstructionsList.add(instructionFormat);
            }
        } catch (FileNotFoundException e) {
            throw new FileNotFoundException("File not found at: " + e.getMessage());
        } catch (Exception e) {
            throw new Exception("Unhandled exception at: " + e.getMessage());
        }

        try (Scanner scanner = new Scanner(new File("Registers.csv"))) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                String[] register = line.split(",");
                Registers.put(register[0].trim(), Integer.valueOf(register[1].trim()));
            }
        } catch (FileNotFoundException e) {
            throw new FileNotFoundException("File not found at: " + e.getMessage());
        } catch (Exception e) {
            throw new Exception("Unhandled exception at: " + e.getMessage());
        }

        File folder = new File("..\\Assembly Code"); // replace with your folder path
        File[] listOfFiles = folder.listFiles();

        if (listOfFiles != null) {
            for (File file : listOfFiles) {
                if (file.isFile()) {
                    try (Scanner scanner = new Scanner(file)) {
                        int pc = 0;
                        while (scanner.hasNextLine()) {
                            String line = scanner.nextLine();
                            if (line.contains(":")) {
                                Labels.put(line.replace(":", ""), pc);
                            }
                            pc += 1;
                        }
                    } catch (FileNotFoundException e) {
                        throw new FileNotFoundException("File not found at: " + e.getMessage());
                    } catch (Exception e) {
                        throw new Exception("Unhandled exception at: " + e.getMessage());
                    }
                }
            }
        } else {
            System.out.println("No files found in the directory.");
        }


    }
    private static String generateRandomFileName(int length) {
        Random random = new Random();
        StringBuilder sb = new StringBuilder(length);
        String characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        for (int i = 0; i < length; i++) {
            int index = random.nextInt(characters.length());
            sb.append(characters.charAt(index));
        }

        return sb.toString();
    }
}
