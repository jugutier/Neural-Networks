package boardBuilder;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;
import java.beans.*;
import java.io.*;
import java.util.*;
import java.util.List;

import javax.imageio.ImageIO;
import javax.swing.*;

public class JFileChooserPreview {
    static int matrix[][][] =  new int[9][8][2];
    public static void main(String[] args) {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        }
        catch(Exception e) { }

        final JFrame frame = new JFrame();
        frame.setLayout(new GridLayout(5, 0, 10, 10));
        final JTextField jtfx = new JTextField("x");
        final JTextField jtfy = new JTextField("y");
        final JTextField jtfz = new JTextField("z");
        JButton button = new JButton("Choose Tile");
        JButton finishB = new JButton("Finish");

        button.addKeyListener(new KeyListener() {
            @Override
            public void keyTyped(KeyEvent keyEvent) {

            }

            @Override
            public void keyPressed(KeyEvent keyEvent) {
                JFileChooser chooser = new JFileChooser("/Users/jugutier/Desktop/mahjong");
                PreviewPane previewPane = new PreviewPane();
                chooser.setAccessory(previewPane);
                chooser.addPropertyChangeListener(previewPane);
                int returnVal = chooser.showDialog(frame, "Add");
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    Integer x =Integer.parseInt(jtfx.getText());
                    Integer y = Integer.parseInt(jtfy.getText());
                    Integer z = Integer.parseInt(jtfz.getText());
                    String tileName = chooser.getSelectedFile()
                            .getName();
                    matrix[x][y][z]= parseName(tileName);
                    System.out.println("x = "+x+"y = "+y+"z = "+z);
                    System.out.println(tileName);

                }
            }

            @Override
            public void keyReleased(KeyEvent keyEvent) {

            }
        });
        finishB.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                System.out.print("{");
                for(int i=0;i<matrix.length;i++){
                    System.out.print("{");
                    for(int j=0;j<matrix[i].length;j++){
                        System.out.print("{");
                        for(int k=0;k<matrix[i][j].length;k++){
                            System.out.print(matrix[i][j][k]);
                            if(k!= matrix[i][j].length -1){
                                System.out.print(",");

                            }
                        }
                        System.out.print("}");
                        if(j!= matrix[i].length -1){
                            System.out.print(",");

                        }
                    }

                    System.out.print("}");
                    if( i!= matrix.length -1){
                        System.out.print(",");

                    }
                }
                System.out.print("}");
                System.out.println();
                frame.dispose();
            }
        });

        frame.getContentPane().add(jtfx,0);
        frame.getContentPane().add(jtfy,1);
        frame.getContentPane().add(jtfz,2);
        frame.getContentPane().add(button);
        frame.getContentPane().add(finishB);

        frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);


    }
    static int parseName(String tileName){
        List<String> tiles = new ArrayList<String>(42);
        tiles.add(String.format("mj%s.png","s1"));//basto
        tiles.add(String.format("mj%s.png", "s2"));
        tiles.add(String.format("mj%s.png", "s3"));
        tiles.add(String.format("mj%s.png","s4"));
        tiles.add(String.format("mj%s.png","s5"));
        tiles.add(String.format("mj%s.png","s6"));
        tiles.add(String.format("mj%s.png","s7"));
        tiles.add( String.format("mj%s.png","s8"));
        tiles.add(String.format("mj%s.png","s9"));
        tiles.add(String.format("mj%s.png","t1"));//circulo
        tiles.add(String.format("mj%s.png","t2"));
        tiles.add(String.format("mj%s.png","t3"));
        tiles.add(String.format("mj%s.png","t4"));
        tiles.add(String.format("mj%s.png","t5"));
        tiles.add(String.format("mj%s.png","t6"));
        tiles.add(String.format("mj%s.png","t7"));
        tiles.add(String.format("mj%s.png","t8"));
        tiles.add(String.format("mj%s.png","t9"));
        tiles.add(String.format("mj%s.png","w1"));//caracter
        tiles.add(String.format("mj%s.png","w2"));
        tiles.add(String.format("mj%s.png","w3"));
        tiles.add(String.format("mj%s.png","w4"));
        tiles.add(String.format("mj%s.png","w5"));
        tiles.add(String.format("mj%s.png","w6"));
        tiles.add(String.format("mj%s.png","w7"));
        tiles.add(String.format("mj%s.png","w8"));
        tiles.add(String.format("mj%s.png","w9"));
        tiles.add(String.format("mj%s.png","d1"));//dragon
        tiles.add(String.format("mj%s.png", "d2"));
        tiles.add(String.format("mj%s.png","d3"));
        tiles.add(String.format("mj%s.png","f1"));//flower
        tiles.add(String.format("mj%s.png","f2"));
        tiles.add(String.format("mj%s.png","f3"));
        tiles.add(String.format("mj%s.png","f4"));
        tiles.add(String.format("mj%s.png","h1"));//mixed
        tiles.add(String.format("mj%s.png","h2"));
        tiles.add(String.format("mj%s.png","h3"));
        tiles.add(String.format("mj%s.png","h4"));
        tiles.add(String.format("mj%s.png","h5"));
        tiles.add(String.format("mj%s.png","h6"));
        tiles.add(String.format("mj%s.png","h7"));
        tiles.add(String.format("mj%s.png","h8"));

        int i =0;
        for(String tile:tiles){
            if(tileName.equalsIgnoreCase(tile)){
                return i;
            }
            i++;
        }

        System.out.println("MENOS UNO!!!");
        return -1;

    }

    static class PreviewPane extends JPanel implements PropertyChangeListener {
        private JLabel label;
        private int maxImgWidth;
        public PreviewPane() {
            setLayout(new BorderLayout(5,5));
            setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
            add(new JLabel("Preview:"), BorderLayout.NORTH);
            label = new JLabel();
            label.setBackground(Color.WHITE);
            label.setOpaque(true);
            label.setPreferredSize(new Dimension(200, 200));
            maxImgWidth = 100;
            label.setBorder(BorderFactory.createEtchedBorder());
            add(label, BorderLayout.CENTER);
        }

        public void propertyChange(PropertyChangeEvent evt) {
            Icon icon = null;
            if(JFileChooser.SELECTED_FILE_CHANGED_PROPERTY.equals(evt
                    .getPropertyName())) {
                File newFile = (File) evt.getNewValue();
                if(newFile != null) {
                    String path = newFile.getAbsolutePath();
                    if(path.endsWith(".gif") || path.endsWith(".jpg") || path.endsWith(".png") || path.endsWith(".bmp")) {
                        try {
                            BufferedImage img = ImageIO.read(newFile);
                            float width = img.getWidth();
                            float height = img.getHeight();
                            float scale = height / width;
                            width = maxImgWidth;
                            height = (width * scale); // height should be scaled from new width
                            icon = new ImageIcon(img.getScaledInstance(Math.max(1, (int)width), Math.max(1, (int)height), Image.SCALE_SMOOTH));
                        }
                        catch(IOException e) {
                            // couldn't read image.
                        }
                    }
                }

                label.setIcon(icon);
                this.repaint();

            }
        }

    }


}
