import java.io.*;
import java.util.Scanner;

public class LambdaFunction {

    public static void main(String[] args){
        LambdaFunction function = new LambdaFunction();
        System.out.println(function.handler());
    }
    public String handler() {
        String output = "file: ";
        try {
            InputStream is = LambdaFunction.class.getResourceAsStream("/resources/test.txt");
            BufferedReader reader = new BufferedReader(new InputStreamReader(is));
            String line;
            while ((line = reader.readLine()) != null) {
                output = line;
            }
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        return output;
    }
}