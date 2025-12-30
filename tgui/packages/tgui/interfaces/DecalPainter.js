import { useBackend, useLocalState } from '../backend';
import { Button, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const DecalPainter = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab, setTab] = useLocalState(context, 'tab', 1);
  return (
    <Window
      width={500}
      height={500}>
      <Window.Content>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 1}
            onClick={() => {
              setTab(1);
              act('slider mode', {
                slider_mode: 0, 
              });
            }}>
            Decals
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 2}
            onClick={() => {
              setTab(2);
              act('slider mode', {
                slider_mode: 1, 
              });
            }}>
            Sliders
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <DecalPrinter />}
        {tab === 2 && <SliderPrinter />}
      </Window.Content>
    </Window>
  );
};

const DecalPrinter = (props, context) => {
  const { act, data } = useBackend(context);
  const decal_list = data.decal_list || [];
  const color_list = data.color_list || [];
  const dir_list = data.dir_list || [];

  return (
    <>
      <Section title="Decal Type">
        {decal_list.map(decal => (
          <Button
            key={decal.decal}
            content={decal.name}
            selected={decal.decal === data.decal_style}
            onClick={() => act('select decal', {
              decals: decal.decal,
            })} />
        ))}
      </Section><Section title="Decal Color">
        {color_list.map(color => {
          return (
            <Button
              key={color.colors}
              content={color.colors === "red"
                ? "Red"
                : color.colors === "white"
                  ? "White"
                  : "Yellow"}
              selected={color.colors === data.decal_color}
              onClick={() => act('select color', {
                colors: color.colors,
              })} />
          );
        })}
        </Section><Section title="Decal Direction">
        {dir_list.map(dir => {
          return (
            <Button
              key={dir.dirs}
              content={dir.dirs === 1
                ? "North"
                : dir.dirs === 2
                  ? "South"
                  : dir.dirs === 4
                    ? "East"
                    : "West"}
              selected={dir.dirs === data.decal_direction}
              onClick={() => act('selected direction', {
                dirs: dir.dirs,
              })} />
          );
        })}
      </Section>
    </>
  );
};

const SliderPrinter = (props, context) => {
  const { act, data } = useBackend(context);
  const slider_list = data.slider_list || [];
  const color_list = data.slider_color_list || [];
  const dir_list = data.slider_dir_list || [];

  return (
    <>
      <Section title="Slider Type">
        {slider_list.map(slider => (
          <Button
            key={slider.slider}
            content={slider.name}
            selected={slider.slider === data.slider_style}
            onClick={() => act('select slider', {
              sliders: slider.slider,
            })} />
        ))}
      </Section><Section title="Slider Color">
        {color_list.map(color => {
          return (
            <Button
              key={color.colors}
              content={color.colors === "#DE3A3A"
                ? "Red"
                : color.colors === "#D381C9"
                  ? "Purple"
                  : color.colors === "#A46106"
                    ? "Brown"
                    : color.colors === "#9FED58"
                      ? "Green"
                      : color.colors === "#EFB341"
                        ? "Yellow"
                        : color.colors === "#440000"
                          ? "Dark Red"
                          : color.colors === "#3234B9"
                            ? "Blue"
                            : color.colors === "#7D6521"
                              ? "Gold"
                              : color.colors === "#52B4E9"
                              ? "Light Blue"
                                : color.colors === "#55391A"
                                  ? "Wood"
                                  : "White"}
              selected={color.colors === data.slider_color}
              onClick={() => act('select slider color', {
                colors: color.colors,
              })} />
          );
        })}
      </Section><Section title="Slider Direction">
        {dir_list.map(dir => {
          return (
            <Button
              key={dir.dirs}
                content={dir.dirs === 1
                  ? "North"
                  : dir.dirs === 2
                    ? "South"
                    : dir.dirs === 4
                      ? "East"
                      : dir.dirs === 5
                        ? "North East"
                        : dir.dirs === 6
                          ? "South East"
                          : dir.dirs === 9
                            ? "North West"
                            : dir.dirs === 10
                              ? "South West"
                              : "West"}
              selected={dir.dirs === data.slider_direction}
              onClick={() => act('selected slider direction', {
                dirs: dir.dirs,
              })} />
          );
        })}
      </Section></>
  );
}
