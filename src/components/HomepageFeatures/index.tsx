import React from "react";
import clsx from "clsx";
import styles from "./styles.module.css";
import { useColorMode } from "@docusaurus/theme-common";
import Card from "@mui/material/Card";
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import Typography from '@mui/material/Typography';
import { CardActionArea } from '@mui/material';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<"svg">>;
  SvgDark: React.ComponentType<React.ComponentProps<"svg">>;
  link?: string;
};

const FeatureList: FeatureItem[] = [
  {
    title: "Memo / メモ",
    Svg: require("@site/static/img/memo.svg").default,
    SvgDark: require("@site/static/img/memo-dark.svg").default,
    link: "./docs/category/root/",
  },
  {
    title: "Blog / ブログ",
    Svg: require("@site/static/img/blog.svg").default,
    SvgDark: require("@site/static/img/blog-dark.svg").default,
    link: "./blog/",
  },
  {
    title: "Books / 読んだ本",
    Svg: require("@site/static/img/books.svg").default,
    SvgDark: require("@site/static/img/books-dark.svg").default,
    // link: "./books/",
  },
];

function Feature({ title, Svg, SvgDark, link }: FeatureItem) {
  const { colorMode } = useColorMode();
  // Svg style
  const IconComponent = colorMode === "dark" ? SvgDark : Svg;
  // Card style
  const commonCardStyle = {
    borderRadius: '20px',
    overflow: 'hidden',
    margin: '0 auto 32px auto',
    width: '300px'
  };
  const colorSpecificCardStyle = colorMode === "dark" ? { backgroundColor: "#242526" } : { backgroundColor: "#fff" };
  const cardStyle = { ...commonCardStyle, ...colorSpecificCardStyle };
  // Text color
  const textColor = colorMode === "dark" ? "white" : "black";

  return (
    <div className={clsx("col col--4")}>
      <a href={link}>
        <Card className={styles.topCard} style={cardStyle}>
          <CardActionArea>
            <div className="text--center">
              <CardMedia>
                <IconComponent className={styles.featureSvg} role="img" style={{ paddingTop: '20px' }}/>
              </CardMedia>
            </div>
            <CardContent>
              <Typography variant="h5" component="div" style={{ color: textColor}}>
                {title}
              </Typography>
            </CardContent>
          </CardActionArea>
        </Card>
      </a>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
