import { useBackend } from '../backend';
import { Button, Section, Flex, Box, AnimatedNumber } from '../components';
import { Window } from '../layouts';

export const AbnormalityWork = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    overload_color,
    plead_color,
    understanding_color,
    threat_color,
    threat,
    name,
    image,
    overload,
    pleading,
    understanding,
    understanding_percent,
    work_knowledge,
  } = data;

  const work_links = data.work_links || [];
  const work_displays = data.work_displays || [];
  const work_chances = data.work_chances || [];

  return (
    <Window
      title="Abnormality Work Console"
      width={400}
      height={350}>
      <Window.Content>
        <Box lineHeight={1.75}>
          <b><span style={{ color: threat_color }}>[{threat}]</span> {name}</b>
          <br />
          {!!overload && (
            <span style={{
              color: overload_color,
            }}>
              Personal Work Success Rates are modified by
              <AnimatedNumber initial={0} value={overload} />%.
              <br />
            </span>
          )}
          {!!pleading && (
            <span style={{
              color: plead_color,
            }}>
              Work on other abnormalities, I beg you...
              <br />
            </span>
          )}
          {!!understanding && (
            <span style={{
              color: understanding_color,
            }}>
              Current Understanding is:&nbsp;
              <AnimatedNumber initial={0} value={understanding_percent} />%,
              granting a&nbsp;
              <AnimatedNumber initial={0} value={understanding} />
              % Work Success and Speed bonus.
              <br />
            </span>
          )}
          <br />
          {!!work_knowledge && (
            <div style={{ float: 'right', width: '52.5%' }}>
              <image src={image} class="fit-picture" width={192} height={192} />
            </div>
          ) || (
            <div style={{ float: 'right', width: '60%' }}>
              <image src={image} class="fit-picture" width={192} height={192} />
            </div>
          )}
          <br />
          {work_links.map(line => (
            <span key={line}>
              {!!work_knowledge && (
                <Button
                  content={
                    work_displays[line]
                      + " ["
                      + work_chances[line]
                      + "%]"
                  }
                  onClick={() => act('do_work', { do_work: line })}
                />
              ) || (
                <Button
                  content={
                    work_displays[line]
                  }
                  onClick={() => act('do_work', { do_work: line })}
                />
              )}
              <br />
            </span>
          ))}
        </Box>

      </Window.Content>
    </Window>
  );
};
