// ** React Import
import { ReactNode } from 'react'

// ** Next Import
import Link from 'next/link'

// ** MUI Imports
import Box, { BoxProps } from '@mui/material/Box'
import { styled } from '@mui/material/styles'

// ** Type Import
import { Settings } from 'src/@core/context/settingsContext'

// ** Configs
import { CardMedia } from '@mui/material'

interface Props {
  hidden: boolean
  settings: Settings
  toggleNavVisibility: () => void
  saveSettings: (values: Settings) => void
  verticalNavMenuBranding?: (props?: any) => ReactNode
}

// ** Styled Components
const MenuHeaderWrapper = styled(Box)<BoxProps>(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
  paddingRight: theme.spacing(4.5),
  transition: 'padding .25s ease-in-out',
  minHeight: theme.mixins.toolbar.minHeight
}))

// const HeaderTitle = styled(Typography)<TypographyProps>(({ theme }) => ({
//   fontWeight: 600,
//   lineHeight: 'normal',
//   textTransform: 'uppercase',
//   color: theme.palette.text.primary,
//   transition: 'opacity .25s ease-in-out, margin .25s ease-in-out'
// }))

// const StyledLink = styled('a')({
//   display: 'flex',
//   alignItems: 'center',
//   textDecoration: 'none'
// })

const VerticalNavHeader = (props: Props) => {
  // ** Props
  const { verticalNavMenuBranding: userVerticalNavMenuBranding } = props

  return (
		<MenuHeaderWrapper className='nav-header'>
			{userVerticalNavMenuBranding ? (
				userVerticalNavMenuBranding(props)
			) : (
				<Link href='/' passHref>
					<CardMedia
						component={'img'}
						src='/images/logos/logo-horizontal.png'
						sx={{
							height: 50,
							width: 'auto'
						}}
					/>
				</Link>
			)}
		</MenuHeaderWrapper>
	)
}

export default VerticalNavHeader
